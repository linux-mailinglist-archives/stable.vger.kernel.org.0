Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D7E697A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfJ0VGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfJ0VF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:05:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28450214AF;
        Sun, 27 Oct 2019 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210357;
        bh=h8lq4nixI4nM9csfCj+ze8GYtJp/yVBqr0i/cifHhj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4WpUucQ9+IWoEVme0adYHzrXXsuQWTIsMVWzQyUsAravv72Gm+TVPn5McYvt2YFm
         YeEtEGIEEnMo2U8HbR3Zkq43/HtBT8CdhEjumEr0+XFfJ0eF7lwwxGZXDI2Mflcvd/
         yQJnyaqvpnxUPgjsA34gbQVTYM6249b4/Zq+Ze8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/49] mac80211: fix txq null pointer dereference
Date:   Sun, 27 Oct 2019 22:00:46 +0100
Message-Id: <20191027203124.336462730@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 8ed31a264065ae92058ce54aa3cc8da8d81dc6d7 ]

If the interface type is P2P_DEVICE or NAN, read the file of
'/sys/kernel/debug/ieee80211/phyx/netdev:wlanx/aqm' will get a
NULL pointer dereference. As for those interface type, the
pointer sdata->vif.txq is NULL.

Unable to handle kernel NULL pointer dereference at virtual address 00000011
CPU: 1 PID: 30936 Comm: cat Not tainted 4.14.104 #1
task: ffffffc0337e4880 task.stack: ffffff800cd20000
PC is at ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
LR is at ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
[...]
Process cat (pid: 30936, stack limit = 0xffffff800cd20000)
[...]
[<ffffff8000b7cd00>] ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
[<ffffff8000b7c414>] ieee80211_if_read+0x60/0xbc [mac80211]
[<ffffff8000b7ccc4>] ieee80211_if_read_aqm+0x28/0x30 [mac80211]
[<ffffff80082eff94>] full_proxy_read+0x2c/0x48
[<ffffff80081eef00>] __vfs_read+0x2c/0xd4
[<ffffff80081ef084>] vfs_read+0x8c/0x108
[<ffffff80081ef494>] SyS_read+0x40/0x7c

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/1569549796-8223-1-git-send-email-miaoqing@codeaurora.org
[trim useless data from commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index bcec1240f41d9..9769db9818d2f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -490,9 +490,14 @@ static ssize_t ieee80211_if_fmt_aqm(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct txq_info *txqi = to_txq_info(sdata->vif.txq);
+	struct txq_info *txqi;
 	int len;
 
+	if (!sdata->vif.txq)
+		return 0;
+
+	txqi = to_txq_info(sdata->vif.txq);
+
 	spin_lock_bh(&local->fq.lock);
 	rcu_read_lock();
 
@@ -657,7 +662,9 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
 
-	if (sdata->local->ops->wake_tx_queue)
+	if (sdata->local->ops->wake_tx_queue &&
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_NAN)
 		DEBUGFS_ADD(aqm);
 }
 
-- 
2.20.1



