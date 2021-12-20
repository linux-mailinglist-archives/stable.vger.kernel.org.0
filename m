Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780BB47AE24
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhLTO63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbhLTO42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A4C08EC99;
        Mon, 20 Dec 2021 06:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15416611B8;
        Mon, 20 Dec 2021 14:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBCBC36AE8;
        Mon, 20 Dec 2021 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011733;
        bh=AWCQaKWL5xZk/NnqRDgAkEWne10sLkTzStW2h+DGb8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9cnKMl/QmJOfSiXnl9vc30aNTrUz0iTZuJH0MLc7mFVuvCEzK3aOHnEI01Om1tAH
         E4Ggg4KJkTA7fRoL5VFgHwSl2e8N3WQSWXHF8D/z6Vbp7aFPgVc03aVSVtMlF65sHi
         GLXEK5k08lKshtuxyfPJXJEWaD/Fp5LbIfQWeDo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+614e82b88a1a4973e534@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/99] mac80211: track only QoS data frames for admission control
Date:   Mon, 20 Dec 2021 15:33:55 +0100
Message-Id: <20211220143030.103025062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d5e568c3a4ec2ddd23e7dc5ad5b0c64e4f22981a ]

For admission control, obviously all of that only works for
QoS data frames, otherwise we cannot even access the QoS
field in the header.

Syzbot reported (see below) an uninitialized value here due
to a status of a non-QoS nullfunc packet, which isn't even
long enough to contain the QoS header.

Fix this to only do anything for QoS data packets.

Reported-by: syzbot+614e82b88a1a4973e534@syzkaller.appspotmail.com
Fixes: 02219b3abca5 ("mac80211: add WMM admission control support")
Link: https://lore.kernel.org/r/20211122124737.dad29e65902a.Ieb04587afacb27c14e0de93ec1bfbefb238cc2a0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 32bc30ec50ec9..7bd42827540ae 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2493,11 +2493,18 @@ static void ieee80211_sta_tx_wmm_ac_notify(struct ieee80211_sub_if_data *sdata,
 					   u16 tx_time)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 tid = ieee80211_get_tid(hdr);
-	int ac = ieee80211_ac_from_tid(tid);
-	struct ieee80211_sta_tx_tspec *tx_tspec = &ifmgd->tx_tspec[ac];
+	u16 tid;
+	int ac;
+	struct ieee80211_sta_tx_tspec *tx_tspec;
 	unsigned long now = jiffies;
 
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	tid = ieee80211_get_tid(hdr);
+	ac = ieee80211_ac_from_tid(tid);
+	tx_tspec = &ifmgd->tx_tspec[ac];
+
 	if (likely(!tx_tspec->admitted_time))
 		return;
 
-- 
2.33.0



