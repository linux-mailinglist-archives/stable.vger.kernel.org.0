Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F892328A85
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhCASSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239328AbhCASLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71AA460249;
        Mon,  1 Mar 2021 17:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620347;
        bh=4VybER3IavOMA4seHo5f6Doje/QSZTxs3TFThHrhSh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3JQUMoz1BC0AozXQTSqIL9ECyM9J566fmphQr0gH0TI0HuwzLBjlSJOZC8Zk3Piy
         GqXtkaZ/fbvV8mqNyCalFpeQ1FQ2JcNL/0Z4iwBL/mVWRPrGY63FminmUfsPOYXVi1
         iVq3xGCn/mdTwfMlMJqrb79jkC4OPLHLy792Dxik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junichi Nomura <junichi.nomura@nec.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 120/775] bpf, devmap: Use GFP_KERNEL for xdp bulk queue allocation
Date:   Mon,  1 Mar 2021 17:04:48 +0100
Message-Id: <20210301161207.608693157@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index f6e9c68afdd42..85d9d1b72a33a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -802,9 +802,7 @@ static int dev_map_notification(struct notifier_block *notifier,
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



