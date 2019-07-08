Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E595621FC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfGHPVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387473AbfGHPVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:21:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4206217D8;
        Mon,  8 Jul 2019 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599273;
        bh=mwOelXsrCuuMKCyZ0wYPajpulkmxdXMTo78dRT5AWPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbUErqVTmgjCKVfFiU7BRxEV2AsD4evkJned2Ep5FHUxxm+2qz03VUoQSFmtlgYVB
         mREcJQ0igO70jP8XuGh9h/jQBY582JgUdSzJ/ZPTSuWKmpZBbLmKMEBFDmyv+RJAd6
         ynFxY8r73UnaJ4Lk2cv98Sps5Ekg2ZDLuf7eUvoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Elsasser <jelsasser@appneta.com>,
        Eric Dumazet <edumazet@google.com>,
        Matteo Croce <mcroce@redhat.com>
Subject: [PATCH 4.9 061/102] net: check before dereferencing netdev_ops during busy poll
Date:   Mon,  8 Jul 2019 17:12:54 +0200
Message-Id: <20190708150529.620430598@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
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

Fixes: ce6aea93f751 ("net: network drivers no longer need to implement ndo_busy_poll()") # 4.9.y
Signed-off-by: Josh Elsasser <jelsasser@appneta.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

No changes since V2[1], resent as per discussiond on -stable[2]. I hope
this is the correct way to send net fixes for older LTS releases, I'm
going off of the latest netdev FAQ:

   For earlier stable releases, each stable branch maintainer is supposed
   to take care of them. If you find any patch is missing from an earlier
   stable branch, please notify stable@vger.kernel.org with either a commit
   ID or a formal patch backported, and CC Dave and other relevant networking
   developers.

[1]: https://patchwork.ozlabs.org/patch/884986/
[2]: https://lore.kernel.org/stable/CAGnkfhx3ykbEsW+=FtpMFWU=_Vnie7RpPYWpWqa1S1HPMXj9kw@mail.gmail.com/


 net/core/dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5083,7 +5083,10 @@ bool sk_busy_loop(struct sock *sk, int n
 		goto out;
 
 	/* Note: ndo_busy_poll method is optional in linux-4.5 */
-	busy_poll = napi->dev->netdev_ops->ndo_busy_poll;
+	if (napi->dev->netdev_ops)
+		busy_poll = napi->dev->netdev_ops->ndo_busy_poll;
+	else
+		busy_poll = NULL;
 
 	do {
 		rc = 0;


