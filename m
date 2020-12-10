Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE82D6B94
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 00:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgLJXJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 18:09:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58836 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388045AbgLJWbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 17:31:17 -0500
Date:   Thu, 10 Dec 2020 22:04:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607637874;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGmPq1i3ayrpyyrVWVoevEjU3QrxYsIort8NEoox4yg=;
        b=hqCVMUfmuuticgtDymRG8jxVgKfcFBzIB8pH+l/OI50m/5MRXQLvICVL5XRnShD1fdU7zS
        uJ2GN/5zKHWIkchNoD1WGnOItSOiUg5KRJkU/eKqkA7yPkxvjEdqmw2mUb8klHvfwutPgX
        PxuxC+UDyZTvbi8Lvmg8wx3Za1npgvVOUw2FbsBKWQXcA3IAtTxnf3xUPNzuQlxz7Em99G
        pCsZ+/QdH1xpbvWOIL0OhbaOeo/eE6OMdHBxPK+a9MOLpXyFe6EYV8M8BD9WRLEgRy8AEG
        IxTXXg6uMXttBc0ctbRWxHTdWpdDUd329F2cgyOpHEm2eQtL7IKG2NjhvZrEaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607637874;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGmPq1i3ayrpyyrVWVoevEjU3QrxYsIort8NEoox4yg=;
        b=Prvbtp9FjBqAtnFs1a+QKMk96kMxUa+7ebchJTMKBOD4BZ2ODJR7oe5dOa363J9JgvnJbH
        4SvbeE4WVTaLGSCA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic/vector: Fix ordering in vector assignment
Cc:     Prarit Bhargava <prarit@redhat.com>,
        "Shung-Hsi Yu" <shung-hsi.yu@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87ft4djtyp.fsf@nanos.tec.linutronix.de>
References: <87ft4djtyp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <160763787305.3364.11404170583920698033.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     190113b4c6531c8e09b31d5235f9b5175cbb0f72
Gitweb:        https://git.kernel.org/tip/190113b4c6531c8e09b31d5235f9b5175cbb0f72
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 10 Dec 2020 21:18:22 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 10 Dec 2020 23:00:54 +01:00

x86/apic/vector: Fix ordering in vector assignment

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

---
 arch/x86/kernel/apic/vector.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 1eac536..758bbf2 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -273,20 +273,24 @@ static int assign_irq_vector_any_locked(struct irq_data *irqd)
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
