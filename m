Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03474F32A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiDEJKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244415AbiDEIwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F57D5E8B;
        Tue,  5 Apr 2022 01:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B882B81C19;
        Tue,  5 Apr 2022 08:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8167C385A0;
        Tue,  5 Apr 2022 08:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148036;
        bh=dJqjmaqKxFV7sUbqP5+pRkKSgwrc/ZXn1ubpRSJTH04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoQxibeYd0wyXtgExbi2nC+q7/N3FSAYcY8/O2iTEiQ4kKz+mvTDG2XipnYlSBwC5
         jaNsEvt+5eU3/Zqtn6w7m2sWe8UxjU+czXeTtYj+rmw7hi9MnnP311C0SAPyjOuKKs
         6tNaVCaJo8s/kse9mYSvoMJw0TQv0p+Hc1IswePw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijith Thotton <sthotton@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0211/1017] crypto: octeontx2 - remove CONFIG_DM_CRYPT check
Date:   Tue,  5 Apr 2022 09:18:44 +0200
Message-Id: <20220405070400.514428164@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Shijith Thotton <sthotton@marvell.com>

[ Upstream commit 2d841af23ae8f398c85dd1ff2dc24b5ec8ba4569 ]

No issues were found while using the driver with dm-crypt enabled. So
CONFIG_DM_CRYPT check in the driver can be removed.

This also fixes the NULL pointer dereference in driver release if
CONFIG_DM_CRYPT is enabled.

...
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
...
Call trace:
 crypto_unregister_alg+0x68/0xfc
 crypto_unregister_skciphers+0x44/0x60
 otx2_cpt_crypto_exit+0x100/0x1a0
 otx2_cptvf_remove+0xf8/0x200
 pci_device_remove+0x3c/0xd4
 __device_release_driver+0x188/0x234
 device_release_driver+0x2c/0x4c
...

Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/marvell/octeontx2/otx2_cptvf_algs.c  | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 877a948469bd..570074e23b60 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1634,16 +1634,13 @@ static inline int cpt_register_algs(void)
 {
 	int i, err = 0;
 
-	if (!IS_ENABLED(CONFIG_DM_CRYPT)) {
-		for (i = 0; i < ARRAY_SIZE(otx2_cpt_skciphers); i++)
-			otx2_cpt_skciphers[i].base.cra_flags &=
-							~CRYPTO_ALG_DEAD;
-
-		err = crypto_register_skciphers(otx2_cpt_skciphers,
-						ARRAY_SIZE(otx2_cpt_skciphers));
-		if (err)
-			return err;
-	}
+	for (i = 0; i < ARRAY_SIZE(otx2_cpt_skciphers); i++)
+		otx2_cpt_skciphers[i].base.cra_flags &= ~CRYPTO_ALG_DEAD;
+
+	err = crypto_register_skciphers(otx2_cpt_skciphers,
+					ARRAY_SIZE(otx2_cpt_skciphers));
+	if (err)
+		return err;
 
 	for (i = 0; i < ARRAY_SIZE(otx2_cpt_aeads); i++)
 		otx2_cpt_aeads[i].base.cra_flags &= ~CRYPTO_ALG_DEAD;
-- 
2.34.1



