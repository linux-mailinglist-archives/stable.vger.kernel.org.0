Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24A129C0A2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818078AbgJ0RRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782211AbgJ0O4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06DB2071A;
        Tue, 27 Oct 2020 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810610;
        bh=uPvT6wpgB/Cf4jeIAQeR2HssPZk4ACx3LP1XxgwzIaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cezg7lU+jTX/3/FeiR3Qoc6OZAj5BYzoq2Yhksgoz/H83udihxZ6Efbnh8uXaKl8y
         wL6oxXHAQWjf7Qc8FipNfirVZtRnHy+Vft1CPo+HkOZcUqHEuJNIrDARL20bK7WAa2
         fgkzWD+2gX6sggblbBUjX9FLK3SYZLzGBbkUXw5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 200/633] ath11k: fix a double free and a memory leak
Date:   Tue, 27 Oct 2020 14:49:03 +0100
Message-Id: <20201027135532.066539040@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 7e8453e35e406981d7c529ff8f804285bc894ba3 ]

clang static analyzer reports this problem

mac.c:6204:2: warning: Attempt to free released memory
        kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The channels pointer is allocated in ath11k_mac_setup_channels_rates()
When it fails midway, it cleans up the memory it has already allocated.
So the error handling needs to skip freeing the memory.

There is a second problem.
ath11k_mac_setup_channels_rates(), allocates 3 channels. err_free
misses releasing ar->mac.sbands[NL80211_BAND_6GHZ].channels

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200906212625.17059-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2836a0f197ab0..fc5be7e8c043e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5824,7 +5824,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ret = ath11k_mac_setup_channels_rates(ar,
 					      cap->supported_bands);
 	if (ret)
-		goto err_free;
+		goto err;
 
 	ath11k_mac_setup_ht_vht_cap(ar, cap, &ht_cap);
 	ath11k_mac_setup_he_cap(ar, cap);
@@ -5938,7 +5938,9 @@ static int __ath11k_mac_register(struct ath11k *ar)
 err_free:
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
 	kfree(ar->mac.sbands[NL80211_BAND_5GHZ].channels);
+	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
 
+err:
 	SET_IEEE80211_DEV(ar->hw, NULL);
 	return ret;
 }
-- 
2.25.1



