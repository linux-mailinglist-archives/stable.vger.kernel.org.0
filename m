Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948E2EECF2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbfKDWBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389061AbfKDWBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:32 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7EF21744;
        Mon,  4 Nov 2019 22:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904891;
        bh=Wsb1jpNxG9ivDzj5wFIaJ9ACM3AStFRA5b98HAahpBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y85INT4+dxh8YLY+C+k5BWoW0YIMl90pss/V4gtRn4TN3Xvg5zBxDH+GJMuvFr1mE
         v0QyN7nUuAP2P8YVFuG9lzGgcYuqw//1tM+5zNyvG5rCYyEi/BLhZKFPQKrMJTVZVc
         llAvKdyuhElr5SZoq9C/+7HDI/KbEkkottK784ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/149] thunderbolt: Use 32-bit writes when writing ring producer/consumer
Date:   Mon,  4 Nov 2019 22:45:00 +0100
Message-Id: <20191104212143.931334324@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 943795219d3cb9f8ce6ce51cad3ffe1f61e95c6b ]

The register access should be using 32-bit reads/writes according to the
datasheet. With the previous generation hardware 16-bit writes have been
working but starting with ICL this is not the case anymore so fix
producer/consumer register update to use correct width register address.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Tested-by: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 5cd6bdfa068f9..d436a1534fc2b 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -142,9 +142,20 @@ static void __iomem *ring_options_base(struct tb_ring *ring)
 	return io;
 }
 
-static void ring_iowrite16desc(struct tb_ring *ring, u32 value, u32 offset)
+static void ring_iowrite_cons(struct tb_ring *ring, u16 cons)
 {
-	iowrite16(value, ring_desc_base(ring) + offset);
+	/*
+	 * The other 16-bits in the register is read-only and writes to it
+	 * are ignored by the hardware so we can save one ioread32() by
+	 * filling the read-only bits with zeroes.
+	 */
+	iowrite32(cons, ring_desc_base(ring) + 8);
+}
+
+static void ring_iowrite_prod(struct tb_ring *ring, u16 prod)
+{
+	/* See ring_iowrite_cons() above for explanation */
+	iowrite32(prod << 16, ring_desc_base(ring) + 8);
 }
 
 static void ring_iowrite32desc(struct tb_ring *ring, u32 value, u32 offset)
@@ -196,7 +207,10 @@ static void ring_write_descriptors(struct tb_ring *ring)
 			descriptor->sof = frame->sof;
 		}
 		ring->head = (ring->head + 1) % ring->size;
-		ring_iowrite16desc(ring, ring->head, ring->is_tx ? 10 : 8);
+		if (ring->is_tx)
+			ring_iowrite_prod(ring, ring->head);
+		else
+			ring_iowrite_cons(ring, ring->head);
 	}
 }
 
@@ -660,7 +674,7 @@ void tb_ring_stop(struct tb_ring *ring)
 
 	ring_iowrite32options(ring, 0, 0);
 	ring_iowrite64desc(ring, 0, 0);
-	ring_iowrite16desc(ring, 0, ring->is_tx ? 10 : 8);
+	ring_iowrite32desc(ring, 0, 8);
 	ring_iowrite32desc(ring, 0, 12);
 	ring->head = 0;
 	ring->tail = 0;
-- 
2.20.1



