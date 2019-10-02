Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E74C920A
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfJBTNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:13:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35288 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729065AbfJBTIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035g-Uy; Wed, 02 Oct 2019 20:08:06 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003bL-F3; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Andrey Konovalov" <andreyknvl@google.com>,
        "WANG Cong" <xiyou.wangcong@gmail.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.747341099@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 19/87] igmp: add a missing spin_lock_init()
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit b4846fc3c8559649277e3e4e6b5cec5348a8d208 upstream.

Andrey reported a lockdep warning on non-initialized
spinlock:

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 1 PID: 4099 Comm: a.out Not tainted 4.12.0-rc6+ #9
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 Call Trace:
  __dump_stack lib/dump_stack.c:16
  dump_stack+0x292/0x395 lib/dump_stack.c:52
  register_lock_class+0x717/0x1aa0 kernel/locking/lockdep.c:755
  ? 0xffffffffa0000000
  __lock_acquire+0x269/0x3690 kernel/locking/lockdep.c:3255
  lock_acquire+0x22d/0x560 kernel/locking/lockdep.c:3855
  __raw_spin_lock_bh ./include/linux/spinlock_api_smp.h:135
  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh ./include/linux/spinlock.h:304
  ip_mc_clear_src+0x27/0x1e0 net/ipv4/igmp.c:2076
  igmpv3_clear_delrec+0xee/0x4f0 net/ipv4/igmp.c:1194
  ip_mc_destroy_dev+0x4e/0x190 net/ipv4/igmp.c:1736

We miss a spin_lock_init() in igmpv3_add_delrec(), probably
because previously we never use it on this code path. Since
we already unlink it from the global mc_tomb list, it is
probably safe not to acquire this spinlock here. It does not
harm to have it although, to avoid conditional locking.

Fixes: c38b7d327aaf ("igmp: acquire pmc lock for ip_mc_clear_src()")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/igmp.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1106,6 +1106,7 @@ static void igmpv3_add_delrec(struct in_
 	pmc = kzalloc(sizeof(*pmc), GFP_KERNEL);
 	if (!pmc)
 		return;
+	spin_lock_init(&pmc->lock);
 	spin_lock_bh(&im->lock);
 	pmc->interface = im->interface;
 	in_dev_hold(in_dev);

