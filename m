Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F12F4513A7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348585AbhKOTyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343757AbhKOTV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F5C6331C;
        Mon, 15 Nov 2021 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001944;
        bh=TuMDX0vo3Zm4oB6/mobRY5UZv9WRM6P+BymZF79XnPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2PW9DtMVEKVDiUn39/gFAJS2Q57jf0uFT7/NclFWZTcPBoJ5llnluwSDwrvg7DIP
         KWZoWpTuP/TQ/1fwnB6od9Gye8vxeFavDdW89H8o1Zpm+hvexs73ltbdLqmTFGOYjB
         LyM4Npar3t009enU97Uu3naQP1L4Y8pYlGxT7U/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/917] wilc1000: fix possible memory leak in cfg_scan_result()
Date:   Mon, 15 Nov 2021 17:57:22 +0100
Message-Id: <20211115165440.521109182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

[ Upstream commit 3c719fed0f3a5e95b1d164609ecc81c4191ade70 ]

When the BSS reference holds a valid reference, it is not freed. The 'if'
condition is wrong. Instead of the 'if (bss)' check, the 'if (!bss)' check
is used.
The issue is solved by removing the unnecessary 'if' check because
cfg80211_put_bss() already performs the NULL validation.

Fixes: 6cd4fa5ab691 ("staging: wilc1000: make use of cfg80211_inform_bss_frame()")
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210916164902.74629-3-ajay.kathat@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 96973ec7bd9ac..87c14969c75fa 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -129,8 +129,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 						info->frame_len,
 						(s32)info->rssi * 100,
 						GFP_KERNEL);
-		if (!bss)
-			cfg80211_put_bss(wiphy, bss);
+		cfg80211_put_bss(wiphy, bss);
 	} else if (scan_event == SCAN_EVENT_DONE) {
 		mutex_lock(&priv->scan_req_lock);
 
-- 
2.33.0



