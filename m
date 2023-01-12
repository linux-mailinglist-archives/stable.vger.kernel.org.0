Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D766741D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjALOCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjALOCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1DE51333
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 199F862028
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB9EC433EF;
        Thu, 12 Jan 2023 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532156;
        bh=Q1J0+QDRDdqbKCV8jK/CSqhRD6+HaxWQ8KpoTNgF/qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4w0kUVRhoUijPNbXK32DK+1Ds8yCJ4pVNcPKU844LvOf4F7YYE1DnnNLnE34bzlv
         QQk2ccGc+Bz6J4EvyfYPnwMsVAxYAuBmzfDSlUHVmY5uW2h+M2p92Q/LQSzLfBG/vM
         W7NEFUT0mAjEJXYWaMp8M2i8PDhMSq+gYSZgVZXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/783] tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
Date:   Thu, 12 Jan 2023 14:45:57 +0100
Message-Id: <20230112135526.035548525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 2b7d07f7acaac2c7750e420dcf4414588ede6d03 ]

The ftpm_mod_init() returns the driver_register() directly without checking
its return value, if driver_register() failed, the ftpm_tee_plat_driver is
not unregistered.

Fix by unregister ftpm_tee_plat_driver when driver_register() failed.

Fixes: 9f1944c23c8c ("tpm_ftpm_tee: register driver on TEE bus")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Maxim Uvarov <maxim.uvarov@linaro.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_ftpm_tee.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ftpm_tee.c b/drivers/char/tpm/tpm_ftpm_tee.c
index 6e3235565a4d..d9daaafdd295 100644
--- a/drivers/char/tpm/tpm_ftpm_tee.c
+++ b/drivers/char/tpm/tpm_ftpm_tee.c
@@ -397,7 +397,13 @@ static int __init ftpm_mod_init(void)
 	if (rc)
 		return rc;
 
-	return driver_register(&ftpm_tee_driver.driver);
+	rc = driver_register(&ftpm_tee_driver.driver);
+	if (rc) {
+		platform_driver_unregister(&ftpm_tee_plat_driver);
+		return rc;
+	}
+
+	return 0;
 }
 
 static void __exit ftpm_mod_exit(void)
-- 
2.35.1



