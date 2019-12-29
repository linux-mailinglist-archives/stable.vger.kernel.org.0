Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC512C414
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfL2R0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbfL2R0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D9420409;
        Sun, 29 Dec 2019 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640370;
        bh=9Q1KOpc9Gr9mqP8t/Q9Bi0RQNfaCGH6IfPJ4qLdMIvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbsHl3Uuy8Qm+3+qqrwRN0/cutP8z2kqpCh4IwvMNlz9k2zXTkR5GR6GRoRXeDI4Z
         7O7rp8pukC8g1RnQO1GjY9Sl6ohnGNxyAcIhmCavVUONzzeZcTCGUQNX+NZlJXXhn0
         I2afu6KlM78sYwGM3db+rbI9nrnOUM4HitFGsjaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/161] mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED
Date:   Sun, 29 Dec 2019 18:19:39 +0100
Message-Id: <20191229162438.526610307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

[ Upstream commit 08a5bdde3812993cb8eb7aa9124703df0de28e4b ]

Commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
let STAs send QoS Null frames as PS triggers if the AP was
a QoS STA.  However, the mac80211 PS stack relies on an
interface flag IEEE80211_STA_NULLFUNC_ACKED for
determining trigger frame ACK, which was not being set for
acked non-QoS Null frames. The effect is an inability to
trigger hardware sleep via IEEE80211_CONF_PS since the QoS
Null frame was seemingly never acked.

This bug only applies to drivers which set both
IEEE80211_HW_REPORTS_TX_ACK_STATUS and
IEEE80211_HW_PS_NULLFUNC_STACK.

Detect the acked QoS Null frame to restore STA power save.

Fixes: 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20191119053538.25979-4-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/status.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b18466cf466c..fbe7354aeac7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -856,7 +856,8 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 			I802_DEBUG_INC(local->dot11FailedCount);
 	}
 
-	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
+	if ((ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
+	    ieee80211_has_pm(fc) &&
 	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    local->ps_sdata && !(local->scanning)) {
-- 
2.20.1



