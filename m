Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA4450B7D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbhKORZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237646AbhKORXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E21D63278;
        Mon, 15 Nov 2021 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996567;
        bh=wdNz7auhgtL1jrlFAmuKZq7q/NXMJzzbJVnl1X4I4ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAq39jwAYTLdA4FC1hbg5X2FmhIBS13wfztG5PAw0b7aZzLhTgsd+5/wL0oGSDgGo
         60eFtJizezKVw/mKb1EZdPMeH3MJQxkR7WYky+iQ5Zz+tvGQjZDe79Se0b/cY4ASFQ
         JZAS2Ow7NwBeCAzuJdN7nqlMSlvEABY9LZIBoNxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/355] wilc1000: fix possible memory leak in cfg_scan_result()
Date:   Mon, 15 Nov 2021 18:01:52 +0100
Message-Id: <20211115165319.854048517@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c3cd6f389a989..2a369fdaf0cbb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -97,8 +97,7 @@ static void cfg_scan_result(enum scan_event scan_event,
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



