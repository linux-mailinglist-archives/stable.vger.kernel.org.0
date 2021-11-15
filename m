Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58814526D2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349431AbhKPCKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239544AbhKOSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6DBA6334B;
        Mon, 15 Nov 2021 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997809;
        bh=+dOCgScBuLGA5rX4r89TlgYq7kAClVxKLevAe1tM21E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDK5Bk7kaXVyAxkir3/hvyXrMApb+5v0dABEfrWL1ePSr8Slt/KCF9CJUFnaGC8jf
         teZEMrQxMDT6vScl560PKBTA0hhjRsev6hQQrmV8ZpBmvIhI9TizdeK42PM3CrtlOW
         yJ/cxZNTtx/npF+cpBQhTkjDwUMn+349e6tq34d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <bqiang@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/575] ath11k: Fix memory leak in ath11k_qmi_driver_event_work
Date:   Mon, 15 Nov 2021 18:00:07 +0100
Message-Id: <20211115165353.530325242@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baochen Qiang <bqiang@codeaurora.org>

[ Upstream commit 72de799aa9e3e064b35238ef053d2f0a49db055a ]

The buffer pointed to by event is not freed in case
ATH11K_FLAG_UNREGISTERING bit is set, resulting in
memory leak, so fix it.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210913180246.193388-4-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 2ae7c6bf091e9..c842e275d1adf 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2616,8 +2616,10 @@ static void ath11k_qmi_driver_event_work(struct work_struct *work)
 		list_del(&event->list);
 		spin_unlock(&qmi->event_lock);
 
-		if (test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags))
+		if (test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)) {
+			kfree(event);
 			return;
+		}
 
 		switch (event->type) {
 		case ATH11K_QMI_EVENT_SERVER_ARRIVE:
-- 
2.33.0



