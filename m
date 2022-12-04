Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D8641DD8
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 17:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLDQPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 11:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiLDQPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 11:15:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AE513FB3
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 08:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 925AA60EB3
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 16:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63A2C433C1;
        Sun,  4 Dec 2022 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670170518;
        bh=IycOi1N6lqfvYOxtaMaHD9DTTeJ1DtEsXGQxdTv+PW4=;
        h=Subject:To:Cc:From:Date:From;
        b=EAuPqdpLk7xAokupqhBxStN2gmTqLA/sl39XO6UWdITjX+ofwCj337sHfCSv34DGv
         Mx7gYH78lIg+m12cJap1arYg0AUDjwiQSWLFNb/4nq/46J6FQpojTXQR+Wn+jr/zXx
         /RJFLLaAdO7/Eov9x9WY80O8BMrx527k0j6nDLfw=
Subject: FAILED: patch "[PATCH] ACPI: HMAT: Fix initiator registration for single-initiator" failed to apply to 6.0-stable tree
To:     vishal.l.verma@intel.com, chris.d.piper@intel.com,
        dan.j.williams@intel.com, kirill.shutemov@linux.intel.com,
        liushixin2@huawei.com, rafael.j.wysocki@intel.com,
        rafael@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Dec 2022 17:15:15 +0100
Message-ID: <1670170515119246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

48d4180939e1 ("ACPI: HMAT: Fix initiator registration for single-initiator systems")
14f16d47561b ("ACPI: HMAT: remove unnecessary variable initialization")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 48d4180939e12c4bd2846f984436d895bb9699ed Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 16 Nov 2022 16:37:37 -0700
Subject: [PATCH] ACPI: HMAT: Fix initiator registration for single-initiator
 systems

In a system with a single initiator node, and one or more memory-only
'target' nodes, the memory-only node(s) would fail to register their
initiator node correctly. i.e. in sysfs:

  # ls /sys/devices/system/node/node0/access0/targets/
  node0

Where as the correct behavior should be:

  # ls /sys/devices/system/node/node0/access0/targets/
  node0 node1

This happened because hmat_register_target_initiators() uses list_sort()
to sort the initiator list, but the sort comparision function
(initiator_cmp()) is overloaded to also set the node mask's bits.

In a system with a single initiator, the list is singular, and list_sort
elides the comparision helper call. Thus the node mask never gets set,
and the subsequent search for the best initiator comes up empty.

Add a new helper to consume the sorted initiator list, and generate the
nodemask, decoupling it from the overloaded initiator_cmp() comparision
callback. This prevents the singular list corner case naturally, and
makes the code easier to follow as well.

Cc: <stable@vger.kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Chris Piper <chris.d.piper@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 144a84f429ed..6cceca64a6bc 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -562,17 +562,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 {
 	struct memory_initiator *ia;
 	struct memory_initiator *ib;
-	unsigned long *p_nodes = priv;
 
 	ia = list_entry(a, struct memory_initiator, node);
 	ib = list_entry(b, struct memory_initiator, node);
 
-	set_bit(ia->processor_pxm, p_nodes);
-	set_bit(ib->processor_pxm, p_nodes);
-
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	struct memory_initiator *initiator;
+
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	list_for_each_entry(initiator, &initiators, node)
+		set_bit(initiator->processor_pxm, p_nodes);
+
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -609,7 +618,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	list_sort(NULL, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -643,7 +655,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)

