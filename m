Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281A2549604
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381247AbiFMOIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381074AbiFMODp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:03:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B2790CE9;
        Mon, 13 Jun 2022 04:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CECD2CE1174;
        Mon, 13 Jun 2022 11:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7891C34114;
        Mon, 13 Jun 2022 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120314;
        bh=sXhm+oMCrui/y0I0+QBtmpIK+POYQhAS48jgfA/2Ycw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKRK+DqZuP+QUyrxRbz5ACpcf2kEAMtYMXN7Pj03Ql6kIoo370ndhmE3QrfOZ1pW8
         +emRuoRJIa8PSkapsjiuGvT0c8se38oyRcF3nkoIAwN7ApLC2t0CbxggEd0f/Zp/Es
         cIbW9LM7erHTRm8Uh4SlhHOkKVfY+cqqMfuORTBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Safford <david.safford@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.18 308/339] KEYS: trusted: tpm2: Fix migratable logic
Date:   Mon, 13 Jun 2022 12:12:13 +0200
Message-Id: <20220613094936.097972286@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Safford <david.safford@gmail.com>

commit dda5384313a40ecbaafd8a9a80f47483255e4c4d upstream.

When creating (sealing) a new trusted key, migratable
trusted keys have the FIXED_TPM and FIXED_PARENT attributes
set, and non-migratable keys don't. This is backwards, and
also causes creation to fail when creating a migratable key
under a migratable parent. (The TPM thinks you are trying to
seal a non-migratable blob under a migratable parent.)

The following simple patch fixes the logic, and has been
tested for all four combinations of migratable and non-migratable
trusted keys and parent storage keys. With this logic, you will
get a proper failure if you try to create a non-migratable
trusted key under a migratable parent storage key, and all other
combinations work correctly.

Cc: stable@vger.kernel.org # v5.13+
Fixes: e5fb5d2c5a03 ("security: keys: trusted: Make sealed key properly interoperable")
Signed-off-by: David Safford <david.safford@gmail.com>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -283,8 +283,8 @@ int tpm2_seal_trusted(struct tpm_chip *c
 	/* key properties */
 	flags = 0;
 	flags |= options->policydigest_len ? 0 : TPM2_OA_USER_WITH_AUTH;
-	flags |= payload->migratable ? (TPM2_OA_FIXED_TPM |
-					TPM2_OA_FIXED_PARENT) : 0;
+	flags |= payload->migratable ? 0 : (TPM2_OA_FIXED_TPM |
+					    TPM2_OA_FIXED_PARENT);
 	tpm_buf_append_u32(&buf, flags);
 
 	/* policy */


