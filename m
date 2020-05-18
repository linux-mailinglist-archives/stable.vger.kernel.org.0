Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BECE1D81DB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgERRv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgERRvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EE320674;
        Mon, 18 May 2020 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824282;
        bh=JLWxNKeoW+Xt08Zdz0NK/R0f/qbmQqADXwS63pO5RSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BV2R2bLytS67bL2chRm9w/6iJsSMwHHqZyHI25sF0Xm3c6fGQXov6c9kU3YNBjPT/
         OXBFChb7VUPzHx6QFZar7a8FK5Fk6UONDPfT18dG+1opVYuX6ULi8RKI2XLv/3R44Q
         Xco6wq+59SizlbWGCC8TuMWtdDQdysaEhk3Lr6o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/80] net: fix a potential recursive NETDEV_FEAT_CHANGE
Date:   Mon, 18 May 2020 19:36:27 +0200
Message-Id: <20200518173452.081921019@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit dd912306ff008891c82cd9f63e8181e47a9cb2fb ]

syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
between bonding master and slave. I managed to find a reproducer
for this:

  ip li set bond0 up
  ifenslave bond0 eth0
  brctl addbr br0
  ethtool -K eth0 lro off
  brctl addif br0 bond0
  ip li set br0 up

When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
it captures this and calls bond_compute_features() to fixup its
master's and other slaves' features. However, when syncing with
its lower devices by netdev_sync_lower_features() this event is
triggered again on slaves when the LRO feature fails to change,
so it goes back and forth recursively until the kernel stack is
exhausted.

Commit 17b85d29e82c intentionally lets __netdev_update_features()
return -1 for such a failure case, so we have to just rely on
the existing check inside netdev_sync_lower_features() and skip
NETDEV_FEAT_CHANGE event only for this specific failure case.

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jann Horn <jannh@google.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8259,11 +8259,13 @@ static void netdev_sync_lower_features(s
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
-			netdev_update_features(lower);
+			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
+			else
+				netdev_features_change(lower);
 		}
 	}
 }


