Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B828D32E98D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhCEMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhCEMdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 307866501A;
        Fri,  5 Mar 2021 12:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947589;
        bh=2O0lwenxAmIM5XsUES+XaigKREFGud5r6uG5Xbus590=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSookPK9iz54UNWd5wGGfHSwvyh2Fst0CJ5UfTZARPaJtZTL9Pqv3rfHapSm0dJIA
         wPMhxZYtXHZR42JA3Jel9nQswEl8EjT2yPEwmwBnYD7EUhkabSxq6zwbmJ6w+KsY0J
         eIRM6uyaY/jhsEl4iJoBwYfPRiyc+5zEc+6Dx15s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 13/72] net/af_iucv: remove WARN_ONCE on malformed RX packets
Date:   Fri,  5 Mar 2021 13:21:15 +0100
Message-Id: <20210305120857.984571475@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 27e9c1de529919d8dd7d072415d3bcae77709300 upstream.

syzbot reported the following finding:

AF_IUCV failed to receive skb, len=0
WARNING: CPU: 0 PID: 522 at net/iucv/af_iucv.c:2039 afiucv_hs_rcv+0x174/0x190 net/iucv/af_iucv.c:2039
CPU: 0 PID: 522 Comm: syz-executor091 Not tainted 5.10.0-rc1-syzkaller-07082-g55027a88ec9f #0
Hardware name: IBM 3906 M04 701 (KVM/Linux)
Call Trace:
 [<00000000b87ea538>] afiucv_hs_rcv+0x178/0x190 net/iucv/af_iucv.c:2039
([<00000000b87ea534>] afiucv_hs_rcv+0x174/0x190 net/iucv/af_iucv.c:2039)
 [<00000000b796533e>] __netif_receive_skb_one_core+0x13e/0x188 net/core/dev.c:5315
 [<00000000b79653ce>] __netif_receive_skb+0x46/0x1c0 net/core/dev.c:5429
 [<00000000b79655fe>] netif_receive_skb_internal+0xb6/0x220 net/core/dev.c:5534
 [<00000000b796ac3a>] netif_receive_skb+0x42/0x318 net/core/dev.c:5593
 [<00000000b6fd45f4>] tun_rx_batched.isra.0+0x6fc/0x860 drivers/net/tun.c:1485
 [<00000000b6fddc4e>] tun_get_user+0x1c26/0x27f0 drivers/net/tun.c:1939
 [<00000000b6fe0f00>] tun_chr_write_iter+0x158/0x248 drivers/net/tun.c:1968
 [<00000000b4f22bfa>] call_write_iter include/linux/fs.h:1887 [inline]
 [<00000000b4f22bfa>] new_sync_write+0x442/0x648 fs/read_write.c:518
 [<00000000b4f238fe>] vfs_write.part.0+0x36e/0x5d8 fs/read_write.c:605
 [<00000000b4f2984e>] vfs_write+0x10e/0x148 fs/read_write.c:615
 [<00000000b4f29d0e>] ksys_write+0x166/0x290 fs/read_write.c:658
 [<00000000b8dc4ab4>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415
Last Breaking-Event-Address:
 [<00000000b8dc64d4>] __s390_indirect_jump_r14+0x0/0xc

Malformed RX packets shouldn't generate any warnings because
debugging info already flows to dropmon via the kfree_skb().

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2176,7 +2176,6 @@ static int afiucv_hs_rcv(struct sk_buff
 	char nullstring[8];
 
 	if (!pskb_may_pull(skb, sizeof(*trans_hdr))) {
-		WARN_ONCE(1, "AF_IUCV failed to receive skb, len=%u", skb->len);
 		kfree_skb(skb);
 		return NET_RX_SUCCESS;
 	}


