Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4249320144A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391580AbgFSPH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391575AbgFSPHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738EB21852;
        Fri, 19 Jun 2020 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579245;
        bh=3PuiUQqDTe/7yEbzJ6QkJxv9BBE61RSsdN3LyjCVq2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnpDFzY3aT+wH8PuSvv9jj2FaCn+usjjgFEvFyy4WZWVfGV751Iazf1oyTZHxkRap
         wnFt/OQd0jUoOBwcrsLKwwnTE/+xfvDOjBGuXIEp5geN5bXb2rzW6kAGth/Puigj6t
         acXHn9g4P+ZG23LjUkeXzey1GKYhiKCt79L8+Vp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/261] ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
Date:   Fri, 19 Jun 2020 16:30:43 +0200
Message-Id: <20200619141651.445535142@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 88eb0ee17b2ece64fcf6689a4557a5c2e7a89c4b ]

The ixgbe driver have another memory model when compiled on archs with
PAGE_SIZE above 4096 bytes. In this mode it doesn't split the page in
two halves, but instead increment rx_buffer->page_offset by truesize of
packet (which include headroom and tailroom for skb_shared_info).

This is done correctly in ixgbe_build_skb(), but in ixgbe_rx_buffer_flip
which is currently only called on XDP_TX and XDP_REDIRECT, it forgets
to add the tailroom for skb_shared_info. This breaks XDP_REDIRECT, for
veth and cpumap.  Fix by adding size of skb_shared_info tailroom.

Maintainers notice: This fix have been queued to Jeff.

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Link: https://lore.kernel.org/bpf/158945344946.97035.17031588499266605743.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index a26f9fb95ac0..edaa0bffa5c3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2254,7 +2254,8 @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
 	rx_buffer->page_offset ^= truesize;
 #else
 	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
-				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) :
+				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
 				SKB_DATA_ALIGN(size);
 
 	rx_buffer->page_offset += truesize;
-- 
2.25.1



