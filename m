Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525513C4E3E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243631AbhGLHRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243636AbhGLHQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB359611ED;
        Mon, 12 Jul 2021 07:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074028;
        bh=Ba3k+lfWlZcVUC2cgA70gQS5MLX+o3B8UTnJgRFxx7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hB5SS5ZP/VFhByXiqJwe+WZMSMx8E0T6hdsuMg4dRXTYszwtMViQ8WRa9RTpd7c1+
         5LRRHvQ4Odw4Jwb0LabMHimAc9S7RMVw4JLwmi2mJuzQb1Rzw7xF63pIwohKlEgxG8
         HsfVsJ9KwAwXQm2HQ/6r3qxorEziuepQXwzyWDjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 438/700] mt76: mt7921: remove redundant check on type
Date:   Mon, 12 Jul 2021 08:08:41 +0200
Message-Id: <20210712061023.060038452@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1921b8925c6f2a171af6294bba6af733da2409b9 ]

Currently in the switch statement case where type is
NL80211_IFTYPE_STATION there is a check to see if type
is not NL80211_IFTYPE_STATION.  This check is always false
and is redundant dead code that can be removed.

Addresses-Coverity: ("Logically dead code")
Fixes: e0f9fdda81bd ("mt76: mt7921: add ieee80211_ops")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index c6e8857067a3..05ba9cdffb1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -239,9 +239,6 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 		if (i)
 			return i - 1;
 
-		if (type != NL80211_IFTYPE_STATION)
-			break;
-
 		/* next, try to find a free repeater entry for the sta */
 		i = get_free_idx(mask >> REPEATER_BSSID_START, 0,
 				 REPEATER_BSSID_MAX - REPEATER_BSSID_START);
-- 
2.30.2



