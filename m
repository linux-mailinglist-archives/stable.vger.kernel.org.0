Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5FA798C8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388052AbfG2Td6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387979AbfG2Td4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:33:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0782821655;
        Mon, 29 Jul 2019 19:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428835;
        bh=cAcRbMmQFhqZjfgA2FaeIp5lhOgqthVDL8dxEd5KDdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmZ1WlAJCKj8vWz6r89MnLUzcM8gkWw+gLSrLgUxGK/7V0vCNs77P8QLOrUVQvJd8
         8fZj/Lwm31pOlzLyOEQjfr8jcBp4oIfmheM5anPfN+CRrTr7g9Q+JswyF1fn1IhawD
         CeTRCLmlMYHz8Sa9zQM5uJnif4FTYRepZIh41hFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Weinelt <martin@linuxlounge.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 202/293] net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling
Date:   Mon, 29 Jul 2019 21:21:33 +0200
Message-Id: <20190729190839.960985249@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit e57f61858b7cf478ed6fa23ed4b3876b1c9625c4 ]

We take a pointer to grec prior to calling pskb_may_pull and use it
afterwards to get nsrcs so record nsrcs before the pull when handling
igmp3 and we get a pointer to nsrcs and call pskb_may_pull when handling
mld2 which again could lead to reading 2 bytes out-of-bounds.

 ==================================================================
 BUG: KASAN: use-after-free in br_multicast_rcv+0x480c/0x4ad0 [bridge]
 Read of size 2 at addr ffff8880421302b4 by task ksoftirqd/1/16

 CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G           OE     5.2.0-rc6+ #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
 Call Trace:
  dump_stack+0x71/0xab
  print_address_description+0x6a/0x280
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  __kasan_report+0x152/0x1aa
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  kasan_report+0xe/0x20
  br_multicast_rcv+0x480c/0x4ad0 [bridge]
  ? br_multicast_disable_port+0x150/0x150 [bridge]
  ? ktime_get_with_offset+0xb4/0x150
  ? __kasan_kmalloc.constprop.6+0xa6/0xf0
  ? __netif_receive_skb+0x1b0/0x1b0
  ? br_fdb_update+0x10e/0x6e0 [bridge]
  ? br_handle_frame_finish+0x3c6/0x11d0 [bridge]
  br_handle_frame_finish+0x3c6/0x11d0 [bridge]
  ? br_pass_frame_up+0x3a0/0x3a0 [bridge]
  ? virtnet_probe+0x1c80/0x1c80 [virtio_net]
  br_handle_frame+0x731/0xd90 [bridge]
  ? select_idle_sibling+0x25/0x7d0
  ? br_handle_frame_finish+0x11d0/0x11d0 [bridge]
  __netif_receive_skb_core+0xced/0x2d70
  ? virtqueue_get_buf_ctx+0x230/0x1130 [virtio_ring]
  ? do_xdp_generic+0x20/0x20
  ? virtqueue_napi_complete+0x39/0x70 [virtio_net]
  ? virtnet_poll+0x94d/0xc78 [virtio_net]
  ? receive_buf+0x5120/0x5120 [virtio_net]
  ? __netif_receive_skb_one_core+0x97/0x1d0
  __netif_receive_skb_one_core+0x97/0x1d0
  ? __netif_receive_skb_core+0x2d70/0x2d70
  ? _raw_write_trylock+0x100/0x100
  ? __queue_work+0x41e/0xbe0
  process_backlog+0x19c/0x650
  ? _raw_read_lock_irq+0x40/0x40
  net_rx_action+0x71e/0xbc0
  ? __switch_to_asm+0x40/0x70
  ? napi_complete_done+0x360/0x360
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? __schedule+0x85e/0x14d0
  __do_softirq+0x1db/0x5f9
  ? takeover_tasklets+0x5f0/0x5f0
  run_ksoftirqd+0x26/0x40
  smpboot_thread_fn+0x443/0x680
  ? sort_range+0x20/0x20
  ? schedule+0x94/0x210
  ? __kthread_parkme+0x78/0xf0
  ? sort_range+0x20/0x20
  kthread+0x2ae/0x3a0
  ? kthread_create_worker_on_cpu+0xc0/0xc0
  ret_from_fork+0x35/0x40

 The buggy address belongs to the page:
 page:ffffea0001084c00 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0
 flags: 0xffffc000000000()
 raw: 00ffffc000000000 ffffea0000cfca08 ffffea0001098608 0000000000000000
 raw: 0000000000000000 0000000000000003 00000000ffffff7f 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
 ffff888042130180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 > ffff888042130280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff888042130300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ==================================================================
 Disabling lock debugging due to kernel taint

Fixes: bc8c20acaea1 ("bridge: multicast: treat igmpv3 report with INCLUDE and no sources as a leave")
Reported-by: Martin Weinelt <martin@linuxlounge.net>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Tested-by: Martin Weinelt <martin@linuxlounge.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1120,6 +1120,7 @@ static int br_ip4_multicast_igmp3_report
 	int type;
 	int err = 0;
 	__be32 group;
+	u16 nsrcs;
 
 	ih = igmpv3_report_hdr(skb);
 	num = ntohs(ih->ngrec);
@@ -1133,8 +1134,9 @@ static int br_ip4_multicast_igmp3_report
 		grec = (void *)(skb->data + len - sizeof(*grec));
 		group = grec->grec_mca;
 		type = grec->grec_type;
+		nsrcs = ntohs(grec->grec_nsrcs);
 
-		len += ntohs(grec->grec_nsrcs) * 4;
+		len += nsrcs * 4;
 		if (!pskb_may_pull(skb, len))
 			return -EINVAL;
 
@@ -1155,7 +1157,7 @@ static int br_ip4_multicast_igmp3_report
 		src = eth_hdr(skb)->h_source;
 		if ((type == IGMPV3_CHANGE_TO_INCLUDE ||
 		     type == IGMPV3_MODE_IS_INCLUDE) &&
-		    ntohs(grec->grec_nsrcs) == 0) {
+		    nsrcs == 0) {
 			br_ip4_multicast_leave_group(br, port, group, vid, src);
 		} else {
 			err = br_ip4_multicast_add_group(br, port, group, vid,
@@ -1190,23 +1192,26 @@ static int br_ip6_multicast_mld2_report(
 	len = skb_transport_offset(skb) + sizeof(*icmp6h);
 
 	for (i = 0; i < num; i++) {
-		__be16 *nsrcs, _nsrcs;
+		__be16 *_nsrcs, __nsrcs;
+		u16 nsrcs;
 
-		nsrcs = skb_header_pointer(skb,
-					   len + offsetof(struct mld2_grec,
-							  grec_nsrcs),
-					   sizeof(_nsrcs), &_nsrcs);
-		if (!nsrcs)
+		_nsrcs = skb_header_pointer(skb,
+					    len + offsetof(struct mld2_grec,
+							   grec_nsrcs),
+					    sizeof(__nsrcs), &__nsrcs);
+		if (!_nsrcs)
 			return -EINVAL;
 
+		nsrcs = ntohs(*_nsrcs);
+
 		if (!pskb_may_pull(skb,
 				   len + sizeof(*grec) +
-				   sizeof(struct in6_addr) * ntohs(*nsrcs)))
+				   sizeof(struct in6_addr) * nsrcs))
 			return -EINVAL;
 
 		grec = (struct mld2_grec *)(skb->data + len);
 		len += sizeof(*grec) +
-		       sizeof(struct in6_addr) * ntohs(*nsrcs);
+		       sizeof(struct in6_addr) * nsrcs;
 
 		/* We treat these as MLDv1 reports for now. */
 		switch (grec->grec_type) {
@@ -1225,7 +1230,7 @@ static int br_ip6_multicast_mld2_report(
 		src = eth_hdr(skb)->h_source;
 		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
 		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
-		    ntohs(*nsrcs) == 0) {
+		    nsrcs == 0) {
 			br_ip6_multicast_leave_group(br, port, &grec->grec_mca,
 						     vid, src);
 		} else {


