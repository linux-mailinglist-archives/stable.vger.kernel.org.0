Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C5B1D85FB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgERRuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730640AbgERRuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507A020715;
        Mon, 18 May 2020 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824214;
        bh=isc2ypdDeaNKoeAr0qghBgsxXZHrsQiYfG69IJWBIOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPZ/F4wLkrIgBpoLhuOO3l4DKcnNIRFHQ2pflM/TRAwsEZDUosgAE69c7qhIsVX45
         QCW6faGzlvyPdFjS9f/kcyjuuf7QKw3UmTBMNnIromtz+WOmSlkjr9JLhO9a8qAK9V
         IAzDDPETEsUDaI7NV+HI4kBpHtDF6QHwgp2a2WqE=
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
Subject: [PATCH 4.14 081/114] net: fix a potential recursive NETDEV_FEAT_CHANGE
Date:   Mon, 18 May 2020 19:36:53 +0200
Message-Id: <20200518173517.131930221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
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
@@ -7282,11 +7282,13 @@ static void netdev_sync_lower_features(s
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


