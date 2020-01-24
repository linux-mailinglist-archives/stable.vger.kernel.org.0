Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC2C148395
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391942AbgAXLgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391938AbgAXLgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:32 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E48206D4;
        Fri, 24 Jan 2020 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865791;
        bh=DNRBfJkOjtOXNEwpblMuae/A81BxwOgV5+t2yRtpzlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHVZPjX8CnGU6o/o+YmBhYNPhizbSfAaP8z2zEdKvJW+JT/QcQtX43hYTmCBzhJ39
         r5FtxZyBl3i7IMxcMJ7xgVgJ6auXUiqMrPc0Dq/lXNDXNG4Sxt173sRB39zyDm+DxB
         wcpenWYVeeCvbwbjmwFJlkw4UObQ/WQ3aNd6qz0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kal Cutter Conley <kal.conley@dectris.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 611/639] xsk: Fix registration of Rx-only sockets
Date:   Fri, 24 Jan 2020 10:33:01 +0100
Message-Id: <20200124093206.006311967@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 2afd23f78f39da84937006ecd24aa664a4ab052b ]

Having Rx-only AF_XDP sockets can potentially lead to a crash in the
system by a NULL pointer dereference in xsk_umem_consume_tx(). This
function iterates through a list of all sockets tied to a umem and
checks if there are any packets to send on the Tx ring. Rx-only
sockets do not have a Tx ring, so this will cause a NULL pointer
dereference. This will happen if you have registered one or more
Rx-only sockets to a umem and the driver is checking the Tx ring even
on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
Rx-only and other sockets tied to the same umem.

Fixed by only putting sockets with a Tx component on the list that
xsk_umem_consume_tx() iterates over.

Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Link: https://lore.kernel.org/bpf/1571645818-16244-1-git-send-email-magnus.karlsson@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index d9117ab035f7c..556a649512b60 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -23,6 +23,9 @@ void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
+	if (!xs->tx)
+		return;
+
 	spin_lock_irqsave(&umem->xsk_list_lock, flags);
 	list_add_rcu(&xs->list, &umem->xsk_list);
 	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
@@ -32,6 +35,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
+	if (!xs->tx)
+		return;
+
 	spin_lock_irqsave(&umem->xsk_list_lock, flags);
 	list_del_rcu(&xs->list);
 	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
-- 
2.20.1



