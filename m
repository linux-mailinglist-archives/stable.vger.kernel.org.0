Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2212E6665
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388289AbgL1NWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388272AbgL1NWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A44E206ED;
        Mon, 28 Dec 2020 13:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161711;
        bh=FVFgeD6GAnJJ54zu38wHBE18rKu95IbcNPBfUQYdYrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aC5pCGG/hOI3zgd30htAh6mBDShM581cY6mzrnfsMwoIv7aAnO3Cg3g+V9IzjMzC6
         Rk7o/Gec8XMyA1wtd9BahpLTM+E8rj8yVGh/vLl8MwJyn51EYCV2B8yoJcOJB3lZp7
         R8NNLaxronGx3kDZMFqkVu4DZp4TIfseejm2G8bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 025/346] x86/apic/vector: Fix ordering in vector assignment
Date:   Mon, 28 Dec 2020 13:45:44 +0100
Message-Id: <20201228124920.990187689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 190113b4c6531c8e09b31d5235f9b5175cbb0f72 upstream.

Prarit reported that depending on the affinity setting the

 ' irq $N: Affinity broken due to vector space exhaustion.'

message is showing up in dmesg, but the vector space on the CPUs in the
affinity mask is definitely not exhausted.

Shung-Hsi provided traces and analysis which pinpoints the problem:

The ordering of trying to assign an interrupt vector in
assign_irq_vector_any_locked() is simply wrong if the interrupt data has a
valid node assigned. It does:

 1) Try the intersection of affinity mask and node mask
 2) Try the node mask
 3) Try the full affinity mask
 4) Try the full online mask

Obviously #2 and #3 are in the wrong order as the requested affinity
mask has to take precedence.

In the observed cases #1 failed because the affinity mask did not contain
CPUs from node 0. That made it allocate a vector from node 0, thereby
breaking affinity and emitting the misleading message.

Revert the order of #2 and #3 so the full affinity mask without the node
intersection is tried before actually affinity is broken.

If no node is assigned then only the full affinity mask and if that fails
the full online mask is tried.

Fixes: d6ffc6ac83b1 ("x86/vector: Respect affinity mask in irq descriptor")
Reported-by: Prarit Bhargava <prarit@redhat.com>
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87ft4djtyp.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/vector.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -274,20 +274,24 @@ static int assign_irq_vector_any_locked(
 	const struct cpumask *affmsk = irq_data_get_affinity_mask(irqd);
 	int node = irq_data_get_node(irqd);
 
-	if (node == NUMA_NO_NODE)
-		goto all;
-	/* Try the intersection of @affmsk and node mask */
-	cpumask_and(vector_searchmask, cpumask_of_node(node), affmsk);
-	if (!assign_vector_locked(irqd, vector_searchmask))
-		return 0;
-	/* Try the node mask */
-	if (!assign_vector_locked(irqd, cpumask_of_node(node)))
-		return 0;
-all:
+	if (node != NUMA_NO_NODE) {
+		/* Try the intersection of @affmsk and node mask */
+		cpumask_and(vector_searchmask, cpumask_of_node(node), affmsk);
+		if (!assign_vector_locked(irqd, vector_searchmask))
+			return 0;
+	}
+
 	/* Try the full affinity mask */
 	cpumask_and(vector_searchmask, affmsk, cpu_online_mask);
 	if (!assign_vector_locked(irqd, vector_searchmask))
 		return 0;
+
+	if (node != NUMA_NO_NODE) {
+		/* Try the node mask */
+		if (!assign_vector_locked(irqd, cpumask_of_node(node)))
+			return 0;
+	}
+
 	/* Try the full online mask */
 	return assign_vector_locked(irqd, cpu_online_mask);
 }


