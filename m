Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D4B643313
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiLETeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiLETdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666242870B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0484C612FB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187AFC433D6;
        Mon,  5 Dec 2022 19:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268521;
        bh=VN8BFLJRkxdNyEhcK/0Wv80q087djHD9wNBnqBF+wZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNeQoNKiCzsEWR44Z8woGBg47w2kTfTBRpMWeLF2a7IvIwH4VCH2FK494KfI64dvr
         4DlYwbm73EyAxvsXh2jqxqdmcRdHWbsQDN8/6J3n5wEe4aWCFL2nY2/C+2jwY5f3KO
         QEMEuQOJiYN3xCP82D7TylqkcloDuSzdFYpzuPrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Liu Shixin <liushixin2@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chris Piper <chris.d.piper@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 120/124] ACPI: HMAT: Fix initiator registration for single-initiator systems
Date:   Mon,  5 Dec 2022 20:10:26 +0100
Message-Id: <20221205190811.858708376@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 48d4180939e12c4bd2846f984436d895bb9699ed ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index fca69a726360..b42653707fdc 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -563,17 +563,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
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
@@ -610,7 +619,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
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
@@ -644,7 +656,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
-- 
2.35.1



