Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88007328E12
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhCATX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241348AbhCATRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A3764F85;
        Mon,  1 Mar 2021 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618522;
        bh=wKR4eAq0JR4Wt5CyFjHBNK1VfbKM5rWDcl/Vkm6HlqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQKjV8/6bruuSth6IS2a0BijxlnEDgXuU9og1hTdual2kIFtLGGRB9EXn+b6QHTWX
         n61+peOSygAuQ1XIZ9oHjlzdK79PFVBWATfO2mA0JJSCYZ/aGK/0Tat9unXLajBXBW
         NqVRvX4qITdV/7j57UkPkENbIE0Pp7AX478w2bJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junichi Nomura <junichi.nomura@nec.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/663] bpf, devmap: Use GFP_KERNEL for xdp bulk queue allocation
Date:   Mon,  1 Mar 2021 17:06:05 +0100
Message-Id: <20210301161147.532143126@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun'ichi Nomura <junichi.nomura@nec.com>

[ Upstream commit 7d4553b69fb335496c597c31590e982485ebe071 ]

The devmap bulk queue is allocated with GFP_ATOMIC and the allocation
may fail if there is no available space in existing percpu pool.

Since commit 75ccae62cb8d42 ("xdp: Move devmap bulk queue into struct net_device")
moved the bulk queue allocation to NETDEV_REGISTER callback, whose context
is allowed to sleep, use GFP_KERNEL instead of GFP_ATOMIC to let percpu
allocator extend the pool when needed and avoid possible failure of netdev
registration.

As the required alignment is natural, we can simply use alloc_percpu().

Fixes: 75ccae62cb8d42 ("xdp: Move devmap bulk queue into struct net_device")
Signed-off-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20210209082451.GA44021@jeru.linux.bs1.fc.nec.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2b5ca93c17dec..b5be9659ab590 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -815,9 +815,7 @@ static int dev_map_notification(struct notifier_block *notifier,
 			break;
 
 		/* will be freed in free_netdev() */
-		netdev->xdp_bulkq =
-			__alloc_percpu_gfp(sizeof(struct xdp_dev_bulk_queue),
-					   sizeof(void *), GFP_ATOMIC);
+		netdev->xdp_bulkq = alloc_percpu(struct xdp_dev_bulk_queue);
 		if (!netdev->xdp_bulkq)
 			return NOTIFY_BAD;
 
-- 
2.27.0



