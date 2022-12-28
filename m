Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280A7657843
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiL1OtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiL1Os5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47331182C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB8E61130
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEC4C433EF;
        Wed, 28 Dec 2022 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238922;
        bh=Q1J0+QDRDdqbKCV8jK/CSqhRD6+HaxWQ8KpoTNgF/qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTnlCDMRMRliglQcU6UpQwTjsdDuEMLHgzEDa/O/9FcFVWAwzTQ/tV1IJJz9iPkhd
         bcscc1idXZsIclPH/JR5liDH4WPitM2uG1oe3ZMWfTFY63deDl6NwNF9KohjZphOLx
         f6pTrid3+z44wQp4h2HNGfIH3upFwvllkV0myJcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Maxim Uvarov <maxim.uvarov@linaro.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/731] tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
Date:   Wed, 28 Dec 2022 15:32:48 +0100
Message-Id: <20221228144258.322132999@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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



