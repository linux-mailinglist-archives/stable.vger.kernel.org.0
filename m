Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F762F143F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbhAKNWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733149AbhAKNSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D1372226A;
        Mon, 11 Jan 2021 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371103;
        bh=p5Wr3XFeeR+EIKIaLO8ZhfGGhhvMQedCgCBrOqHpBx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOkOwupC+9twUNpE9NU4NnYhAIjLhMW8MjoHkUKClZZyPd3xIrq76LzK7Cu//tcLX
         Tnj3sM+hOuBqq8UDpnKPtaTlYaFNRCkUgS8TCdggP/8uEss3tpAwBpQbgKrdjstCP2
         CjlVp+nka7IRYrpwYN1H6ymPuXRYPyasXuPAsBZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.10 144/145] xsk: Fix memory leak for failed bind
Date:   Mon, 11 Jan 2021 14:02:48 +0100
Message-Id: <20210111130055.426774651@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 8bee683384087a6275c9183a483435225f7bb209 upstream.

Fix a possible memory leak when a bind of an AF_XDP socket fails. When
the fill and completion rings are created, they are tied to the
socket. But when the buffer pool is later created at bind time, the
ownership of these two rings are transferred to the buffer pool as
they might be shared between sockets (and the buffer pool cannot be
created until we know what we are binding to). So, before the buffer
pool is created, these two rings are cleaned up with the socket, and
after they have been transferred they are cleaned up together with
the buffer pool.

The problem is that ownership was transferred before it was absolutely
certain that the buffer pool could be created and initialized
correctly and when one of these errors occurred, the fill and
completion rings did neither belong to the socket nor the pool and
where therefore leaked. Solve this by moving the ownership transfer
to the point where the buffer pool has been completely set up and
there is no way it can fail.

Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20201214085127.3960-1-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xdp/xsk.c           |    4 ++++
 net/xdp/xsk_buff_pool.c |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -772,6 +772,10 @@ static int xsk_bind(struct socket *sock,
 		}
 	}
 
+	/* FQ and CQ are now owned by the buffer pool and cleaned up with it. */
+	xs->fq_tmp = NULL;
+	xs->cq_tmp = NULL;
+
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
 	xs->queue_id = qid;
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -75,8 +75,6 @@ struct xsk_buff_pool *xp_create_and_assi
 
 	pool->fq = xs->fq_tmp;
 	pool->cq = xs->cq_tmp;
-	xs->fq_tmp = NULL;
-	xs->cq_tmp = NULL;
 
 	for (i = 0; i < pool->free_heads_cnt; i++) {
 		xskb = &pool->heads[i];


