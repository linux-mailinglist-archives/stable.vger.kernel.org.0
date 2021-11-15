Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5824526D0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349021AbhKPCKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239394AbhKOSAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F35836333C;
        Mon, 15 Nov 2021 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997785;
        bh=AJd5YrBdyTEJOqHpYoDbaQLIjauHUnAGPz5EY1rtVSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmDL9lR3z9tSXFXZxCbe+Zs4JfAGgmlAO6wB4sqRn2BWZX9TVx7mdk/+V4QlhSCf/
         DUNSy6SNQ1PRD5Kr6PJuNiK2W45XFNfUzW5cXiAmoXOis8bvJ/ui/bVP3v0VyALPUm
         qfOhUpbWPvOJZoYtawy2MfApvBcj4jVlN2iDahHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/575] wilc1000: fix possible memory leak in cfg_scan_result()
Date:   Mon, 15 Nov 2021 17:59:59 +0100
Message-Id: <20211115165353.252330585@linuxfoundation.org>
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
index c1ac1d84790f0..6be5ac8ba518d 100644
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



