Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A749928F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348790AbiAXUVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45856 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349645AbiAXUTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:19:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0716091B;
        Mon, 24 Jan 2022 20:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EE0C340E5;
        Mon, 24 Jan 2022 20:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055570;
        bh=qIu40SqUO5KD28fEgzEEHatZGMorjGgeu74zFz8rpis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CGHNVIGqiv5aDDPIcha6wUjA2S2+7U/4F+BRAnrXWOLuFw+efVmUxmmFgMGowH8L
         In2WcuDQmP33SP5x1ll1w8dQZ9IteLrOzoPv7ECT1nxHSDw5sJ9JWDq30u2QmPq1a/
         zb1XCZ1izHUAteJNb1PlEr9rfY/BI6APjyze5N2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/846] staging: rtl8192e: return error code from rtllib_softmac_init()
Date:   Mon, 24 Jan 2022 19:35:12 +0100
Message-Id: <20220124184107.677026184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



