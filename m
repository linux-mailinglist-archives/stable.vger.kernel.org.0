Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B75023A5BF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgHCMc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgHCMc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:32:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87112076B;
        Mon,  3 Aug 2020 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457947;
        bh=tRCAR+29801nJlV6nn6fx12W0QoTWA6SQQ+ift7Kwg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/kvzCSkRNpKs+xvUTUITFdHBtnwF8p2aa/jylpTxLhMIv6i9l8gtrh7nChByEk5a
         8CU7I+S/xic20wQnzBvJiF/NsOViHG87AdDixyUHJMeQSnL0H4+rR2U7xeG0hWElbu
         hSkisPfQX0tXlz2sJ3Kja+NCqH1HlK6w+Goda1gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/56] mac80211: mesh: Free pending skb when destroying a mpath
Date:   Mon,  3 Aug 2020 14:19:55 +0200
Message-Id: <20200803121852.281619470@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 5e43540c2af0a0c0a18e39579b1ad49541f87506 ]

A mpath object can hold reference on a list of skb that are waiting for
mpath resolution to be sent. When destroying a mpath this skb list
should be cleaned up in order to not leak memory.

Fixing that kind of leak:

unreferenced object 0xffff0000181c9300 (size 1088):
  comm "openvpn", pid 1782, jiffies 4295071698 (age 80.416s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f9 80 36 00 00 00 00 00  ..........6.....
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000004bc6a443>] kmem_cache_alloc+0x1a4/0x2f0
    [<000000002caaef13>] sk_prot_alloc.isra.39+0x34/0x178
    [<00000000ceeaa916>] sk_alloc+0x34/0x228
    [<00000000ca1f1d04>] inet_create+0x198/0x518
    [<0000000035626b1c>] __sock_create+0x134/0x328
    [<00000000a12b3a87>] __sys_socket+0xb0/0x158
    [<00000000ff859f23>] __arm64_sys_socket+0x40/0x58
    [<00000000263486ec>] el0_svc_handler+0xd0/0x1a0
    [<0000000005b5157d>] el0_svc+0x8/0xc
unreferenced object 0xffff000012973a40 (size 216):
  comm "openvpn", pid 1782, jiffies 4295082137 (age 38.660s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 06 16 00 00 ff ff 00 93 1c 18 00 00 ff ff  ................
  backtrace:
    [<000000004bc6a443>] kmem_cache_alloc+0x1a4/0x2f0
    [<0000000023c8c8f9>] __alloc_skb+0xc0/0x2b8
    [<000000007ad950bb>] alloc_skb_with_frags+0x60/0x320
    [<00000000ef90023a>] sock_alloc_send_pskb+0x388/0x3c0
    [<00000000104fb1a3>] sock_alloc_send_skb+0x1c/0x28
    [<000000006919d2dd>] __ip_append_data+0xba4/0x11f0
    [<0000000083477587>] ip_make_skb+0x14c/0x1a8
    [<0000000024f3d592>] udp_sendmsg+0xaf0/0xcf0
    [<000000005aabe255>] inet_sendmsg+0x5c/0x80
    [<000000008651ea08>] __sys_sendto+0x15c/0x218
    [<000000003505c99b>] __arm64_sys_sendto+0x74/0x90
    [<00000000263486ec>] el0_svc_handler+0xd0/0x1a0
    [<0000000005b5157d>] el0_svc+0x8/0xc

Fixes: 2bdaf386f99c (mac80211: mesh: move path tables into if_mesh)
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://lore.kernel.org/r/20200704135419.27703-1-repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ac1f5db529945..4fc720c77e37e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -532,6 +532,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl,
 	del_timer_sync(&mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	atomic_dec(&tbl->entries);
+	mesh_path_flush_pending(mpath);
 	kfree_rcu(mpath, rcu);
 }
 
-- 
2.25.1



