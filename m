Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED721EAD7C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgFASpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbgFASJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F752068D;
        Mon,  1 Jun 2020 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034959;
        bh=EttFuyWUsVA2+0so7dutokKTLb7us68VFKlExgm5ag4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY3Mua8zv/Vm0hDJnr9vKY+pLPHZP3rkk+GNJ9TZUgRG34vDxMXVz402XaGrgaSBM
         EK2dCf7tt+XYxJNjOBPLI0WcboOnOefiOPdX/Sjv7EFDvgc2gfIb/5O3aezwzLXWdx
         jUsC2IcaTPO7oz2EIpTHrc+FBqJius81tmhopi8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/142] drivers: net: hamradio: Fix suspicious RCU usage warning in bpqether.c
Date:   Mon,  1 Jun 2020 19:53:40 +0200
Message-Id: <20200601174044.350949290@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 95f59bf88bb75281cc626e283ecefdd5d5641427 ]

This patch fixes the following warning:
=============================
WARNING: suspicious RCU usage
5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
-----------------------------
drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader section!!

Since rtnl lock is held, pass this cond in list_for_each_entry_rcu().

Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index fbea6f232819..e2ad3c2e8df5 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -127,7 +127,8 @@ static inline struct net_device *bpq_get_ax25_dev(struct net_device *dev)
 {
 	struct bpqdev *bpq;
 
-	list_for_each_entry_rcu(bpq, &bpq_devices, bpq_list) {
+	list_for_each_entry_rcu(bpq, &bpq_devices, bpq_list,
+				lockdep_rtnl_is_held()) {
 		if (bpq->ethdev == dev)
 			return bpq->axdev;
 	}
-- 
2.25.1



