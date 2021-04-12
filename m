Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE93C35BFDA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhDLJHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240266AbhDLJF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DBB361363;
        Mon, 12 Apr 2021 09:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218156;
        bh=2jwYS1m2BqG0TDY0c5Xs/sHQYKr3UatGNYg7dG0eV9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsYW/EMvPkLeKgjoi9haHDfif8TkPNwTCZS9vEeI2IXrpLF60wxRJCN4c0gv7l/oE
         6dXDvbbwOCvLB5FMdUS8WE7w+ioeVIUEBAOmF91nWdJevEpDIxF5g/RX2bkbdiTiSF
         y4lIuH1VgikchNJslAF6cimJc1aLmSxHoiXl2nVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.11 057/210] libbpf: Only create rx and tx XDP rings when necessary
Date:   Mon, 12 Apr 2021 10:39:22 +0200
Message-Id: <20210412084017.902195404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

commit ca7a83e2487ad0bc9a3e0e7a8645354aa1782f13 upstream.

Prior to this commit xsk_socket__create(_shared) always attempted to create
the rx and tx rings for the socket. However this causes an issue when the
socket being setup is that which shares the fd with the UMEM. If a
previous call to this function failed with this socket after the rings were
set up, a subsequent call would always fail because the rings are not torn
down after the first call and when we try to set them up again we encounter
an error because they already exist. Solve this by remembering whether the
rings were set up by introducing new bools to struct xsk_umem which
represent the ring setup status and using them to determine whether or
not to set up the rings.

Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210331061218.1647-4-ciara.loftus@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/xsk.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -54,6 +54,8 @@ struct xsk_umem {
 	int fd;
 	int refcount;
 	struct list_head ctx_list;
+	bool rx_ring_setup_done;
+	bool tx_ring_setup_done;
 };
 
 struct xsk_ctx {
@@ -782,6 +784,7 @@ int xsk_socket__create_shared(struct xsk
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 	bool unmap = umem->fill_save != fill;
+	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -809,6 +812,8 @@ int xsk_socket__create_shared(struct xsk
 		}
 	} else {
 		xsk->fd = umem->fd;
+		rx_setup_done = umem->rx_ring_setup_done;
+		tx_setup_done = umem->tx_ring_setup_done;
 	}
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
@@ -827,7 +832,7 @@ int xsk_socket__create_shared(struct xsk
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
+	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
 				 sizeof(xsk->config.rx_size));
@@ -835,8 +840,10 @@ int xsk_socket__create_shared(struct xsk
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
-	if (tx) {
+	if (tx && !tx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
 				 &xsk->config.tx_size,
 				 sizeof(xsk->config.tx_size));
@@ -844,6 +851,8 @@ int xsk_socket__create_shared(struct xsk
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);


