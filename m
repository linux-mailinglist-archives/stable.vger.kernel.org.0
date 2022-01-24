Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9349A9E8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323808AbiAYD3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58614 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376965AbiAXVGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ACD4B8121C;
        Mon, 24 Jan 2022 21:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E9BC340E7;
        Mon, 24 Jan 2022 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058374;
        bh=qIu40SqUO5KD28fEgzEEHatZGMorjGgeu74zFz8rpis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOukcjk6Qtd9KmgQOCdUYenvjx4wrtwOZIeKM82+tlW5hPSZhc7n1o9vJq0hfaadT
         IptbsggcpYOtJRVd6JpxSymkkbsQVZkOwtXSRrdYkQ2K3uHP0bteAz+Jr+GXVZDb8m
         YtJF8VDCpFaD1Xf1U1NfQ+35cEyEltZ5PItKB+PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0226/1039] staging: rtl8192e: return error code from rtllib_softmac_init()
Date:   Mon, 24 Jan 2022 19:33:35 +0100
Message-Id: <20220124184132.928520449@linuxfoundation.org>
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
index c6f8b772335c1..c985e4ebc545a 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1980,7 +1980,7 @@ void SendDisassociation(struct rtllib_device *ieee, bool deauth, u16 asRsn);
 void rtllib_softmac_xmit(struct rtllib_txb *txb, struct rtllib_device *ieee);
 
 void rtllib_start_ibss(struct rtllib_device *ieee);
-void rtllib_softmac_init(struct rtllib_device *ieee);
+int rtllib_softmac_init(struct rtllib_device *ieee);
 void rtllib_softmac_free(struct rtllib_device *ieee);
 void rtllib_disassociate(struct rtllib_device *ieee);
 void rtllib_stop_scan(struct rtllib_device *ieee);
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index d2726d01c7573..503d33be71d99 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2952,7 +2952,7 @@ void rtllib_start_protocol(struct rtllib_device *ieee)
 	}
 }
 
-void rtllib_softmac_init(struct rtllib_device *ieee)
+int rtllib_softmac_init(struct rtllib_device *ieee)
 {
 	int i;
 
@@ -2963,7 +2963,8 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 		ieee->seq_ctrl[i] = 0;
 	ieee->dot11d_info = kzalloc(sizeof(struct rt_dot11d_info), GFP_ATOMIC);
 	if (!ieee->dot11d_info)
-		netdev_err(ieee->dev, "Can't alloc memory for DOT11D\n");
+		return -ENOMEM;
+
 	ieee->LinkDetectInfo.SlotIndex = 0;
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod = 0;
@@ -3029,6 +3030,7 @@ void rtllib_softmac_init(struct rtllib_device *ieee)
 
 	tasklet_setup(&ieee->ps_task, rtllib_sta_ps);
 
+	return 0;
 }
 
 void rtllib_softmac_free(struct rtllib_device *ieee)
-- 
2.34.1



