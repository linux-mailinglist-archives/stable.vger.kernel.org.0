Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549F81D8470
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbgERSC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732517AbgERSC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A3C21531;
        Mon, 18 May 2020 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824946;
        bh=iMihi8owIMhhtIY0aZ2L0HimIy2ey9tF7Onc9PxSMck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdJ8fe9Qx7ZRLxQsQ6gLfdVdQMfGxKbRoaVy+/Fgbhcc6Op1VBL5sJEEMu66i7HBc
         myczJR/fyiCRF4Eful6EqxhVrQCTsLc1kMac+em5CA49IAi7EBUapmsxEgF9RCkDod
         siUI85bA1r676GMNReCmsgHBeG6spjrhtvVgGpUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 040/194] virtio_net: fix lockdep warning on 32 bit
Date:   Mon, 18 May 2020 19:35:30 +0200
Message-Id: <20200518173535.083722916@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 01c3259818a11f3cc3cd767adbae6b45849c03c1 ]

When we fill up a receive VQ, try_fill_recv currently tries to count
kicks using a 64 bit stats counter. Turns out, on a 32 bit kernel that
uses a seqcount. sequence counts are "lock" constructs where you need to
make sure that writers are serialized.

In turn, this means that we mustn't run two try_fill_recv concurrently.
Which of course we don't. We do run try_fill_recv sometimes from a
softirq napi context, and sometimes from a fully preemptible context,
but the later always runs with napi disabled.

However, when it comes to the seqcount, lockdep is trying to enforce the
rule that the same lock isn't accessed from preemptible and softirq
context - it doesn't know about napi being enabled/disabled. This causes
a false-positive warning:

WARNING: inconsistent lock state
...
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.

As a work around, shut down the warning by switching
to u64_stats_update_begin_irqsave - that works by disabling
interrupts on 32 bit only, is a NOP on 64 bit.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1231,9 +1231,11 @@ static bool try_fill_recv(struct virtnet
 			break;
 	} while (rq->vq->num_free);
 	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
-		u64_stats_update_begin(&rq->stats.syncp);
+		unsigned long flags;
+
+		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
 		rq->stats.kicks++;
-		u64_stats_update_end(&rq->stats.syncp);
+		u64_stats_update_end_irqrestore(&rq->stats.syncp, flags);
 	}
 
 	return !oom;


