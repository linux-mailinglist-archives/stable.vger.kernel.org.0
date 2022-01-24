Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4772F499712
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446674AbiAXVJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442438AbiAXVEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA294611C8;
        Mon, 24 Jan 2022 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B649CC340E5;
        Mon, 24 Jan 2022 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058269;
        bh=TVOUWNBzfDhAxoXUMjAv2R95FzmE2kWLWGzml5e+0xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkA0pBWpT8cSAQV4qRVyi5Q42etiWy1+2ZDb0hnlzU77ERghJyVklM3reDsphF32o
         DqXOxkjadu1MH0tXj21MqYleAw5NOigWP+iEzURw8tD5mh35BJ/YL3F5KOZSih2m6P
         eWNlASbiyi5OxyjgeQ1McqSoyOzqzAmJYfybkHls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0227/1039] staging: rtl8192e: rtllib_module: fix error handle case in alloc_rtllib()
Date:   Mon, 24 Jan 2022 19:33:36 +0100
Message-Id: <20220124184132.960193685@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e730cd57ac2dfe94bca0f14a3be8e1b21de41a9c ]

Some variables are leaked in the error handling in alloc_rtllib(), free
the variables in the error path.

Fixes: 94a799425eee ("From: wlanfae <wlanfae@realtek.com>")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211202030704.2425621-3-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib_module.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index 64d9feee1f392..f00ac94b2639b 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -88,7 +88,7 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 	err = rtllib_networks_allocate(ieee);
 	if (err) {
 		pr_err("Unable to allocate beacon storage: %d\n", err);
-		goto failed;
+		goto free_netdev;
 	}
 	rtllib_networks_initialize(ieee);
 
@@ -121,11 +121,13 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 	ieee->hwsec_active = 0;
 
 	memset(ieee->swcamtable, 0, sizeof(struct sw_cam_table) * 32);
-	rtllib_softmac_init(ieee);
+	err = rtllib_softmac_init(ieee);
+	if (err)
+		goto free_crypt_info;
 
 	ieee->pHTInfo = kzalloc(sizeof(struct rt_hi_throughput), GFP_KERNEL);
 	if (!ieee->pHTInfo)
-		return NULL;
+		goto free_softmac;
 
 	HTUpdateDefaultSetting(ieee);
 	HTInitializeHTInfo(ieee);
@@ -141,8 +143,14 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 
 	return dev;
 
- failed:
+free_softmac:
+	rtllib_softmac_free(ieee);
+free_crypt_info:
+	lib80211_crypt_info_free(&ieee->crypt_info);
+	rtllib_networks_free(ieee);
+free_netdev:
 	free_netdev(dev);
+
 	return NULL;
 }
 EXPORT_SYMBOL(alloc_rtllib);
-- 
2.34.1



