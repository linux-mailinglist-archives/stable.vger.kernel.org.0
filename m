Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA82766765B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjALObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbjALOaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D735DE43
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA331B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E27C433EF;
        Thu, 12 Jan 2023 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533307;
        bh=Q3y9vALH9h1rU+RebOmrtFuTgf/yZ+V4xxFKJAIgKHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IF3o6Gb+Fbd7uc5Z2AsYYzYliA2vi5+l10te7UGPX/zd0CsjGah+QDRsgFMnhkOzI
         JhV9BtqEMXBVwtf9C3T/XJ/m7sEEffllyCybYm2oq6BvHh6WQu1yEH1LpJsVJ4bwJm
         5SOqw0Nc0RGBvjKiNyX8u8RyWoe+L11eD4AjipmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/783] HSI: omap_ssi_core: Fix error handling in ssi_init()
Date:   Thu, 12 Jan 2023 14:52:02 +0100
Message-Id: <20230112135543.138489589@linuxfoundation.org>
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

[ Upstream commit 3ffa9f713c39a213a08d9ff13ab983a8aa5d8b5d ]

The ssi_init() returns the platform_driver_register() directly without
checking its return value, if platform_driver_register() failed, the
ssi_pdriver is not unregistered.
Fix by unregister ssi_pdriver when the last platform_driver_register()
failed.

Fixes: 0fae198988b8 ("HSI: omap_ssi: built omap_ssi and omap_ssi_port into one module")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 052cf3e92dd6..26f2c3c01297 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -631,7 +631,13 @@ static int __init ssi_init(void) {
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&ssi_port_pdriver);
+	ret = platform_driver_register(&ssi_port_pdriver);
+	if (ret) {
+		platform_driver_unregister(&ssi_pdriver);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(ssi_init);
 
-- 
2.35.1



