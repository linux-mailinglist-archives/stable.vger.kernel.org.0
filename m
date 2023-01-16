Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC4A66C6E6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjAPQ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjAPQZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:25:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D025E3C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD039B81063
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE1CC433F0;
        Mon, 16 Jan 2023 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885653;
        bh=DMvURGM4N3eFvPfZhcUjsdUy++11HfosTP8UrN7TDR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fU3pyhJKFRuPy0+W9v5NXYIDwpr4IW9xwaSx7C7qAnxddnn27jP/DOlgXc0eUwdBO
         1R5tQUuEsj9g/YL3q/CZckcNEeEaEJf2z4mJNJNRMSDhKFPYt2jLuOqrIaTP5PMaJQ
         kIO5u4u1hTsqBwKfnyVWAWotuCVq9Mw3vgcNwCWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/658] wifi: ath10k: Fix return value in ath10k_pci_init()
Date:   Mon, 16 Jan 2023 16:43:42 +0100
Message-Id: <20230116154915.575189852@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 2af7749047d8d6ad43feff69f555a13a6a6c2831 ]

This driver is attempting to register to support two different buses.
if either of these is successful then ath10k_pci_init() should return 0
so that hardware attached to the successful bus can be probed and
supported. only if both of these are unsuccessful should ath10k_pci_init()
return an errno.

Fixes: 0b523ced9a3c ("ath10k: add basic skeleton to support ahb")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221110061926.18163-1-xiujianfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0f055e577749..c28328c96307 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3769,18 +3769,22 @@ static struct pci_driver ath10k_pci_driver = {
 
 static int __init ath10k_pci_init(void)
 {
-	int ret;
+	int ret1, ret2;
 
-	ret = pci_register_driver(&ath10k_pci_driver);
-	if (ret)
+	ret1 = pci_register_driver(&ath10k_pci_driver);
+	if (ret1)
 		printk(KERN_ERR "failed to register ath10k pci driver: %d\n",
-		       ret);
+		       ret1);
 
-	ret = ath10k_ahb_init();
-	if (ret)
-		printk(KERN_ERR "ahb init failed: %d\n", ret);
+	ret2 = ath10k_ahb_init();
+	if (ret2)
+		printk(KERN_ERR "ahb init failed: %d\n", ret2);
 
-	return ret;
+	if (ret1 && ret2)
+		return ret1;
+
+	/* registered to at least one bus */
+	return 0;
 }
 module_init(ath10k_pci_init);
 
-- 
2.35.1



