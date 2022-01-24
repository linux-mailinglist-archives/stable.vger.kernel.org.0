Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A6498F8D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiAXTxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44556 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356825AbiAXTr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:47:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B71A0614B8;
        Mon, 24 Jan 2022 19:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE9DC340E5;
        Mon, 24 Jan 2022 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053645;
        bh=oBOWS0qSB6my7suxv9Ogc5k8rMLJFocX8CChj6AC7Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isNRp2DzAMwGmFOzswwxySklLLEyf3CVn+mcUuCSCsuVtr3ueTuH29abXRO+lyWA2
         /Lf28kdT90gEI+RMrszDqh9L7GYzWLuE6qVQ1Crgal3ZzrVqXwtFE2gM9Sy55U45WB
         BeY7J4JG1WCOoylbPJ+DS2jQPbORafAmECm4GivI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/563] staging: rtl8192e: return error code from rtllib_softmac_init()
Date:   Mon, 24 Jan 2022 19:38:16 +0100
Message-Id: <20220124184028.929857277@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 68bf78ff59a0891eb1239948e94ce10f73a9dd30 ]

If it fails to allocate 'dot11d_info', rtllib_softmac_init()
should return error code. And remove unneccessary error message.

Fixes: 94a799425eee ("From: wlanfae <wlanfae@realtek.com>")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211202030704.2425621-2-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtllib.h         | 2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 4cabaf21c1ca0..367db4acc7852 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1982,7 +1982,7 @@ void rtllib_softmac_xmit(struct rtllib_txb *txb, struct rtllib_device *ieee);
 void rtllib_stop_send_beacons(struct rtllib_device *ieee);
 void notify_wx_assoc_event(struct rtllib_device *ieee);
 void rtllib_start_ibss(struct rtllib_device *ieee);
-void rtllib_softmac_init(struct rtllib_device *ieee);
+int rtllib_softmac_init(struct rtllib_device *ieee);
 void rtllib_softmac_free(struct rtllib_device *ieee);
 void rtllib_disassociate(struct rtllib_device *ieee);
 void rtllib_stop_scan(struct rtllib_device *ieee);
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 2c752ba5a802a..e8e72f79ca007 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2953,7 +2953,7 @@ void rtllib_start_protocol(struct rtllib_device *ieee)
 	}
 }
 
-void rtllib_softmac_init(struct rtllib_device *ieee)
+int rtllib_softmac_init(struct rtllib_device *ieee)
 {
 	int i;
 
@@ -2964,7 +2964,8 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 		ieee->seq_ctrl[i] = 0;
 	ieee->dot11d_info = kzalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
 	if (!ieee->dot11d_info)
-		netdev_err(ieee->dev, "Can't alloc memory for DOT11D\n");
+		return -ENOMEM;
+
 	ieee->LinkDetectInfo.SlotIndex = 0;
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod = 0;
@@ -3030,6 +3031,7 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 
 	tasklet_setup(&ieee->ps_task, rtllib_sta_ps);
 
+	return 0;
 }
 
 void rtllib_softmac_free(struct rtllib_device *ieee)
-- 
2.34.1



