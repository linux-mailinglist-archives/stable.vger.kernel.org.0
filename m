Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C175235BDFC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhDLI4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238627AbhDLIyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A31061019;
        Mon, 12 Apr 2021 08:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217540;
        bh=hQlqZh9elZT42GXnSsOSFG6g8keysEe8zDkHuEQRSpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTs8AM0wyQn8zNECiEkFqNIBkiVSCzM5dnj/fk+nwm2Y4UWOAjuXV7nDE/NBjW0Y8
         GXd95HLdgPTc4fJrqOxCoLv2/yZ/jO2Wg6+BN8ZCO3O3wWwDBeeavZRQZ5t10G+ldE
         9eddxTcdk8nDc4p4xgqpRVmI0l8RAq5OoSuvQAM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 050/188] libbpf: Only create rx and tx XDP rings when necessary
Date:   Mon, 12 Apr 2021 10:39:24 +0200
Message-Id: <20210412084015.299113306@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -708,6 +710,7 @@ int xsk_socket__create_shared(struct xsk
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 	bool unmap = umem->fill_save != fill;
+	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -735,6 +738,8 @@ int xsk_socket__create_shared(struct xsk
 		}
 	} else {
 		xsk->fd = umem->fd;
+		rx_setup_done = umem->rx_ring_setup_done;
+		tx_setup_done = umem->tx_ring_setup_done;
 	}
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
@@ -753,7 +758,7 @@ int xsk_socket__create_shared(struct xsk
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
+	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
 				 sizeof(xsk->config.rx_size));
@@ -761,8 +766,10 @@ int xsk_socket__create_shared(struct xsk
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
@@ -770,6 +777,8 @@ int xsk_socket__create_shared(struct xsk
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->rx_ring_setup_done = true;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);


