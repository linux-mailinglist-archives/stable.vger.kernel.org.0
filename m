Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D83EEE3D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfKDWI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfKDWI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:56 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42DF3214E0;
        Mon,  4 Nov 2019 22:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905335;
        bh=LCcfkCOh2sKhl+CJURGrELfHhNY9DuqerqxwPCTQnJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kk3lZuLkpbxF0jhoC5YKVcNljSMivdw9xalQaX+G/gPBjHiNWejjLJUF9nuDC4T3q
         Ai+vN0BnRjgTv2aTwhOzH15j3sY1l0cHvfhrN7loFNGP1JjkzcW3shtQD5Ltr703rd
         Ytk7Gst+gesrnucEUUdmhEAJ/Lqq+4TTDbOwo9xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 093/163] thunderbolt: Use 32-bit writes when writing ring producer/consumer
Date:   Mon,  4 Nov 2019 22:44:43 +0100
Message-Id: <20191104212146.895567720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
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
index 27fbe62c7ddd4..9c782706e652f 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -143,9 +143,20 @@ static void __iomem *ring_options_base(struct tb_ring *ring)
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
@@ -197,7 +208,10 @@ static void ring_write_descriptors(struct tb_ring *ring)
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
 
@@ -662,7 +676,7 @@ void tb_ring_stop(struct tb_ring *ring)
 
 	ring_iowrite32options(ring, 0, 0);
 	ring_iowrite64desc(ring, 0, 0);
-	ring_iowrite16desc(ring, 0, ring->is_tx ? 10 : 8);
+	ring_iowrite32desc(ring, 0, 8);
 	ring_iowrite32desc(ring, 0, 12);
 	ring->head = 0;
 	ring->tail = 0;
-- 
2.20.1



