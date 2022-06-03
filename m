Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6597C53CF51
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiFCRyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347253AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4565C8;
        Fri,  3 Jun 2022 10:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61899611F3;
        Fri,  3 Jun 2022 17:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F29C385A9;
        Fri,  3 Jun 2022 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278675;
        bh=yyrGhqI8IVeC53hKFu4TYqVuzOZWCA2X3vdF+q2ZsDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1EH13+Z0fcc4XhTWOHTL50ChRHZwSn1Jy8Zl9M6ogVPYsOQ68wBYcLytUP6HZQQS
         4I03VzP+atPuXRocRTRNmTjT7U8pzGkGplmA2Z7aZHJ0tZP1NvSweRKnujV8d7JJXk
         Q3wyFkQPe373Fz5fP3rXQ+l3iv7Vi7p4fc6pBd1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 57/66] tpm: Fix buffer access in tpm2_get_tpm_pt()
Date:   Fri,  3 Jun 2022 19:43:37 +0200
Message-Id: <20220603173822.306766090@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>

commit e57b2523bd37e6434f4e64c7a685e3715ad21e9a upstream.

Under certain conditions uninitialized memory will be accessed.
As described by TCG Trusted Platform Module Library Specification,
rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
requesting a capability, the TPM in field upgrade mode may return a
zero length list.
Check the property count in tpm2_get_tpm_pt().

Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -400,7 +400,16 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip
 	if (!rc) {
 		out = (struct tpm2_get_cap_out *)
 			&buf.data[TPM_HEADER_SIZE];
-		*value = be32_to_cpu(out->value);
+		/*
+		 * To prevent failing boot up of some systems, Infineon TPM2.0
+		 * returns SUCCESS on TPM2_Startup in field upgrade mode. Also
+		 * the TPM2_Getcapability command returns a zero length list
+		 * in field upgrade mode.
+		 */
+		if (be32_to_cpu(out->property_cnt) > 0)
+			*value = be32_to_cpu(out->value);
+		else
+			rc = -ENODATA;
 	}
 	tpm_buf_destroy(&buf);
 	return rc;


