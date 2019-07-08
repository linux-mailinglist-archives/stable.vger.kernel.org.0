Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82166217F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732654AbfGHPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732648AbfGHPQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF89216E3;
        Mon,  8 Jul 2019 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599005;
        bh=2qhzfsLtRC+4/kABIINMSLG+GVDZvREe7CyKIpCpHPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5pOcczNbddipoOgshQ0enhhF9Q+f/KoLO0g+0B9lFJZEtsgVrHUMGgcyJMQEkcwr
         /wMPM3rT7NIlvMg+KiQWprh8J+BvoHVxe5cfqNksxT8UB5P3MxVGIu+z0sBKfRV+CG
         a5r5xsKkS+TsJVLegAs5POATIczZeNtHRn2tNiWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Elsasser <jelsasser@appneta.com>
Subject: [PATCH 4.4 46/73] net: check before dereferencing netdev_ops during busy poll
Date:   Mon,  8 Jul 2019 17:12:56 +0200
Message-Id: <20190708150523.819580216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Elsasser <jelsasser@appneta.com>

init_dummy_netdev() leaves its netdev_ops pointer zeroed. This leads
to a NULL pointer dereference when sk_busy_loop fires against an iwlwifi
wireless adapter and checks napi->dev->netdev_ops->ndo_busy_poll.

Avoid this by ensuring napi->dev->netdev_ops is valid before following
the pointer, avoiding the following panic when busy polling on a dummy
netdev:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
  IP: [<ffffffff817b4b72>] sk_busy_loop+0x92/0x2f0
  Call Trace:
   [<ffffffff815a3134>] ? uart_write_room+0x74/0xf0
   [<ffffffff817964a9>] sock_poll+0x99/0xa0
   [<ffffffff81223142>] do_sys_poll+0x2e2/0x520
   [<ffffffff8118d3fc>] ? get_page_from_freelist+0x3bc/0xa30
   [<ffffffff810ada22>] ? update_curr+0x62/0x140
   [<ffffffff811ea671>] ? __slab_free+0xa1/0x2a0
   [<ffffffff811ea671>] ? __slab_free+0xa1/0x2a0
   [<ffffffff8179dbb1>] ? skb_free_head+0x21/0x30
   [<ffffffff81221bd0>] ? poll_initwait+0x50/0x50
   [<ffffffff811eaa36>] ? kmem_cache_free+0x1c6/0x1e0
   [<ffffffff815a4884>] ? uart_write+0x124/0x1d0
   [<ffffffff810bd1cd>] ? remove_wait_queue+0x4d/0x60
   [<ffffffff810bd224>] ? __wake_up+0x44/0x50
   [<ffffffff81582731>] ? tty_write_unlock+0x31/0x40
   [<ffffffff8158c5c6>] ? tty_ldisc_deref+0x16/0x20
   [<ffffffff81584820>] ? tty_write+0x1e0/0x2f0
   [<ffffffff81587e50>] ? process_echoes+0x80/0x80
   [<ffffffff8120c17b>] ? __vfs_write+0x2b/0x130
   [<ffffffff8120d09a>] ? vfs_write+0x15a/0x1a0
   [<ffffffff81223455>] SyS_poll+0x75/0x100
   [<ffffffff819a6524>] entry_SYSCALL_64_fastpath+0x24/0xcf

Commit 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()")
indirectly fixed this upstream in linux-4.11 by removing the offending
pointer usage. No other users of napi->dev touch its netdev_ops.

Fixes: 8b80cda536ea ("net: rename include/net/ll_poll.h to include/net/busy_poll.h") # 4.4.y
Signed-off-by: Josh Elsasser <jelsasser@appneta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

This is a straightforward backport of the 4.9.y fix[1] for this crash, which doesn't
apply to the older LTS releases. Only build-tested on 4.4.y, as I don't have access
to wireless hardware and firmware that runs on older LTS kernels.

[1]: https://lore.kernel.org/stable/20190701234143.72631-1-jelsasser@appneta.com/T/#u

 include/net/busy_poll.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -93,7 +93,7 @@ static inline bool sk_busy_loop(struct s
 		goto out;
 
 	ops = napi->dev->netdev_ops;
-	if (!ops->ndo_busy_poll)
+	if (!ops || !ops->ndo_busy_poll)
 		goto out;
 
 	do {


