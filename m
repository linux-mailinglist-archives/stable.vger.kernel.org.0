Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54599A31
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbfHVRKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390723AbfHVRJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:18 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740DE2342B;
        Thu, 22 Aug 2019 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493757;
        bh=ag69XH0HK/mqy35v/SJsvTO77r9YWwBqbkrfQzcvab4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdeHmwPkTYJKek4WVF05jdvm9TSfJCqPCkHEC2X9kv4HbjxIApAxCKgc6bJZ6X5Tn
         Yu87OVFITmzlIFq/igrwhtMdTv/TX5Ww5+8pIAqCCDGDHsxMXQSrNlgXulV3xWFIL5
         vgbW1CzWRuRhTciF+NtEDg3iZNJGMufy1G2ywLQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 117/135] xen/netback: Reset nr_frags before freeing skb
Date:   Thu, 22 Aug 2019 13:07:53 -0400
Message-Id: <20190822170811.13303-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 3a0233ddec554b886298de2428edb5c50a20e694 ]

At this point nr_frags has been incremented but the frag does not yet
have a page assigned so freeing the skb results in a crash. Reset
nr_frags before freeing the skb to prevent this.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7d..c9262ffeefe4c 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -925,6 +925,7 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			skb_shinfo(skb)->nr_frags = MAX_SKB_FRAGS;
 			nskb = xenvif_alloc_skb(0);
 			if (unlikely(nskb == NULL)) {
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				xenvif_tx_err(queue, &txreq, extra_count, idx);
 				if (net_ratelimit())
@@ -940,6 +941,7 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 			if (xenvif_set_skb_gso(queue->vif, skb, gso)) {
 				/* Failure in xenvif_set_skb_gso is fatal. */
+				skb_shinfo(skb)->nr_frags = 0;
 				kfree_skb(skb);
 				kfree_skb(nskb);
 				break;
-- 
2.20.1

