Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD1658174
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiL1Q2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiL1Q2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8521CA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170ED61578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8EFC433D2;
        Wed, 28 Dec 2022 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244657;
        bh=Q3y9vALH9h1rU+RebOmrtFuTgf/yZ+V4xxFKJAIgKHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBc26ecEg6YrXDxESH+YwuC48u5CbvdGQgVVAg+1UIqrPp8moZ9R2PlAa2+oBnQoE
         fkd4JhCK9Kp1KwimLQw+z7VYM3r9+9TGIhiUTXwwf2HDJz6OmTDcvEx+MPMhhsWeER
         dAnsXNQbnnnWpFTM+ZiOigfDbq+QkqeruBVkONoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0749/1073] HSI: omap_ssi_core: Fix error handling in ssi_init()
Date:   Wed, 28 Dec 2022 15:38:57 +0100
Message-Id: <20221228144348.365936215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



