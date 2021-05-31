Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93533395F84
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhEaOMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhEaOKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 051E86197F;
        Mon, 31 May 2021 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468440;
        bh=gLN9xRhtMut5ybpyzUePqsoPUTJ5b+eBpwH+/zoWfZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia6MiL1B1mfllAtSiLc1i1uOo+0ZU4QCFDik6f+ESrkNUik6AqcB002BYLqox+2gf
         coWGqz+XwxdSim1KnRNKHGQJ78xScxHOCYLFBkxqKhgobBc08HDBuZQp0rYjD/7O01
         28bmUv7DE6qpdCyryzTkoTkTfDx+OgGAEIssxgX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH 5.10 244/252] samples/bpf: Consider frame size in tx_only of xdpsock sample
Date:   Mon, 31 May 2021 15:15:09 +0200
Message-Id: <20210531130706.303010579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 3b80d106e110d39d3f678954d3b55078669cf07e upstream.

Fix the tx_only micro-benchmark in xdpsock to take frame size into
consideration. It was hardcoded to the default value of frame_size
which is 4K. Changing this on the command line to 2K made half of the
packets illegal as they were outside the umem and were therefore
discarded by the kernel.

Fixes: 46738f73ea4f ("samples/bpf: add use of need_wakeup flag in xdpsock")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20210506124349.6666-1-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/bpf/xdpsock_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1257,7 +1257,7 @@ static void tx_only(struct xsk_socket_in
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
-		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
 		tx_desc->len = PKT_SIZE;
 	}
 


