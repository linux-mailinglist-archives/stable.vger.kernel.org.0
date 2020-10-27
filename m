Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD129C071
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781893AbgJ0O4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752756AbgJ0O4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD79B22202;
        Tue, 27 Oct 2020 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810575;
        bh=eOGM9rpSEQQRWRaVrP5iOrIVcnmW/+L6A4CfHBRiS8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeEGYlBJSTnRxo5ru6mxZBuuKkQmQCieIZw/XXkFXh0gwQQMnP5abHjw9lRNcPth+
         ALQQ+tuxAcQgRmzX4repWcZKnhsBuOe/Z85s3lvb243JRL9wOyXikEDt6YLkuUQiqB
         reyozTzyOF3LJT/evCNr42OCAsOataRW4RoMiP+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weqaar Janjua <weqaar.a.janjua@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 188/633] samples/bpf: Fix to xdpsock to avoid recycling frames
Date:   Tue, 27 Oct 2020 14:48:51 +0100
Message-Id: <20201027135531.508398182@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weqaar Janjua <weqaar.a.janjua@intel.com>

[ Upstream commit b69e56cf765155dcac0037d7d0f162a2afab76c2 ]

The txpush program in the xdpsock sample application is supposed
to send out all packets in the umem in a round-robin fashion.
The problem is that it only cycled through the first BATCH_SIZE
worth of packets. Fixed this so that it cycles through all buffers
in the umem as intended.

Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for AF_XDP access")
Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20200828161717.42705-1-weqaar.a.janjua@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index c91e91362a0c6..0151bb0b2fc71 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -921,7 +921,7 @@ static void rx_drop_all(void)
 	}
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
+static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
@@ -934,14 +934,14 @@ static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
-		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
 		tx_desc->len = PKT_SIZE;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
 	xsk->outstanding_tx += batch_size;
-	frame_nb += batch_size;
-	frame_nb %= NUM_FRAMES;
+	*frame_nb += batch_size;
+	*frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk, batch_size);
 }
 
@@ -997,7 +997,7 @@ static void tx_only_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			tx_only(xsks[i], frame_nb[i], batch_size);
+			tx_only(xsks[i], &frame_nb[i], batch_size);
 
 		pkt_cnt += batch_size;
 
-- 
2.25.1



