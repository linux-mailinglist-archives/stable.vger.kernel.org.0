Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2DA4F308A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350214AbiDEKvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345706AbiDEJnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD22C4E2F;
        Tue,  5 Apr 2022 02:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E98AEB81CAE;
        Tue,  5 Apr 2022 09:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60471C385A3;
        Tue,  5 Apr 2022 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150935;
        bh=KRNK4njVsHVBRUVwoLTSxSdSTi/Wg8AxT7cHVB6pSlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENaom5YincphP6p+n+kSZE9DVY9YJibAf4zuO77HBWXEDnZaBpnR+F0SveK9syKk9
         MVaRxFnpVqpOTrmVE96tkwGmJ8E00ERF2RHCfohBQMyJWFCYP/Gfwdyve7ZWkmfuQw
         aLvaBMWK2sk4zGz2D/vBIJnewgW0IwHwPO7TTMDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Sumit Garg <sumit.garg@linaro.org>,
        Andreas Rammhold <andreas@rammhold.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/913] KEYS: trusted: Fix trusted key backends when building as module
Date:   Tue,  5 Apr 2022 09:21:36 +0200
Message-Id: <20220405070346.869676721@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Rammhold <andreas@rammhold.de>

[ Upstream commit 969a26446bcd142faedfe8c6f41cd7668596c1fa ]

Before this commit the kernel could end up with no trusted key sources
even though both of the currently supported backends (TPM and TEE) were
compiled as modules. This manifested in the trusted key type not being
registered at all.

When checking if a CONFIG_… preprocessor variable is defined we only
test for the builtin (=y) case and not the module (=m) case. By using
the IS_REACHABLE() macro we do test for both cases.

Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Andreas Rammhold <andreas@rammhold.de>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index d5c891d8d353..5b35f1b87644 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -27,10 +27,10 @@ module_param_named(source, trusted_key_source, charp, 0);
 MODULE_PARM_DESC(source, "Select trusted keys source (tpm or tee)");
 
 static const struct trusted_key_source trusted_key_sources[] = {
-#if defined(CONFIG_TCG_TPM)
+#if IS_REACHABLE(CONFIG_TCG_TPM)
 	{ "tpm", &trusted_key_tpm_ops },
 #endif
-#if defined(CONFIG_TEE)
+#if IS_REACHABLE(CONFIG_TEE)
 	{ "tee", &trusted_key_tee_ops },
 #endif
 };
-- 
2.34.1



