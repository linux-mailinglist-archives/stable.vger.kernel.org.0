Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550972ABA1C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbgKINPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732711AbgKINPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB4120867;
        Mon,  9 Nov 2020 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927749;
        bh=WwrdyJ6rev8UyFlG0RTKTPWToaElwvLFV3wOtR5Dg1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqSLP1/tLFMrsF6oVXziQzs82nDmDI77C5NpyHGn3i2xXiCUEVRk6lRBFn45FV6Q/
         gZDk8B5Ru0zUTZMrtKB8we9PK6vkD3MtfGdmUi7cgrx4CLYErDNmtvmTBhOOz9P6Sh
         8d+Fxf9Y4QhDbhFvl4RGOGzqB6oetyhbyNDLXfV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 001/133] net: core: use list_del_init() instead of list_del() in netdev_run_todo()
Date:   Mon,  9 Nov 2020 13:54:23 +0100
Message-Id: <20201109125030.785403629@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 0e8b8d6a2d85344d80dda5beadd98f5f86e8d3d3 upstream.

dev->unlink_list is reused unless dev is deleted.
So, list_del() should not be used.
Due to using list_del(), dev->unlink_list can't be reused so that
dev->nested_level update logic doesn't work.
In order to fix this bug, list_del_init() should be used instead
of list_del().

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond0 master bond1
    ip link set bond0 nomaster
    ip link set bond1 master bond0
    ip link set bond1 nomaster

Splat looks like:
[  255.750458][ T1030] ============================================
[  255.751967][ T1030] WARNING: possible recursive locking detected
[  255.753435][ T1030] 5.9.0-rc8+ #772 Not tainted
[  255.754553][ T1030] --------------------------------------------
[  255.756047][ T1030] ip/1030 is trying to acquire lock:
[  255.757304][ T1030] ffff88811782a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync_multiple+0xc2/0x150
[  255.760056][ T1030]
[  255.760056][ T1030] but task is already holding lock:
[  255.761862][ T1030] ffff88811130a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.764581][ T1030]
[  255.764581][ T1030] other info that might help us debug this:
[  255.766645][ T1030]  Possible unsafe locking scenario:
[  255.766645][ T1030]
[  255.768566][ T1030]        CPU0
[  255.769415][ T1030]        ----
[  255.770259][ T1030]   lock(&dev_addr_list_lock_key/1);
[  255.771629][ T1030]   lock(&dev_addr_list_lock_key/1);
[  255.772994][ T1030]
[  255.772994][ T1030]  *** DEADLOCK ***
[  255.772994][ T1030]
[  255.775091][ T1030]  May be due to missing lock nesting notation
[  255.775091][ T1030]
[  255.777182][ T1030] 2 locks held by ip/1030:
[  255.778299][ T1030]  #0: ffffffffb1f63250 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2e4/0x8b0
[  255.780600][ T1030]  #1: ffff88811130a280 (&dev_addr_list_lock_key/1){+...}-{2:2}, at: bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.783411][ T1030]
[  255.783411][ T1030] stack backtrace:
[  255.784874][ T1030] CPU: 7 PID: 1030 Comm: ip Not tainted 5.9.0-rc8+ #772
[  255.786595][ T1030] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  255.789030][ T1030] Call Trace:
[  255.789850][ T1030]  dump_stack+0x99/0xd0
[  255.790882][ T1030]  __lock_acquire.cold.71+0x166/0x3cc
[  255.792285][ T1030]  ? register_lock_class+0x1a30/0x1a30
[  255.793619][ T1030]  ? rcu_read_lock_sched_held+0x91/0xc0
[  255.794963][ T1030]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  255.796246][ T1030]  lock_acquire+0x1b8/0x850
[  255.797332][ T1030]  ? dev_mc_sync_multiple+0xc2/0x150
[  255.798624][ T1030]  ? bond_enslave+0x3d4d/0x43e0 [bonding]
[  255.800039][ T1030]  ? check_flags+0x50/0x50
[  255.801143][ T1030]  ? lock_contended+0xd80/0xd80
[  255.802341][ T1030]  _raw_spin_lock_nested+0x2e/0x70
[  255.803592][ T1030]  ? dev_mc_sync_multiple+0xc2/0x150
[  255.804897][ T1030]  dev_mc_sync_multiple+0xc2/0x150
[  255.806168][ T1030]  bond_enslave+0x3d58/0x43e0 [bonding]
[  255.807542][ T1030]  ? __lock_acquire+0xe53/0x51b0
[  255.808824][ T1030]  ? bond_update_slave_arr+0xdc0/0xdc0 [bonding]
[  255.810451][ T1030]  ? check_chain_key+0x236/0x5e0
[  255.811742][ T1030]  ? mutex_is_locked+0x13/0x50
[  255.812910][ T1030]  ? rtnl_is_locked+0x11/0x20
[  255.814061][ T1030]  ? netdev_master_upper_dev_get+0xf/0x120
[  255.815553][ T1030]  do_setlink+0x94c/0x3040
[ ... ]

Reported-by: syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com
Fixes: 1fc70edb7d7b ("net: core: add nested_level variable in net_device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20201015162606.9377-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10134,7 +10134,7 @@ void netdev_run_todo(void)
 		struct net_device *dev = list_first_entry(&unlink_list,
 							  struct net_device,
 							  unlink_list);
-		list_del(&dev->unlink_list);
+		list_del_init(&dev->unlink_list);
 		dev->nested_level = dev->lower_level - 1;
 	}
 #endif


