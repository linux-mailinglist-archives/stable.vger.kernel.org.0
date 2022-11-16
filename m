Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7BC62B455
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiKPH5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 02:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiKPH5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 02:57:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5123154;
        Tue, 15 Nov 2022 23:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668585470; x=1700121470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=verj7hVUBInaUTF3sejWeZjrgjgv2y6v3Lf9mbwz5Qg=;
  b=ktiYYRaVPz2+PliAKTwVkG3LO+dbbsgvG4mS+EWHYgtczXej+6FLOe6x
   nA4gyqwT5Z8+sHjvI4mZalfPbu+GzQUpU/Zf9sU19/W9UtfhAjHtoRuAe
   hKFRtiu95z7BKsLCIkJArAC1zPtX8Pd5p8L+whwy3HgAbrCerdif6YPGJ
   XUylVolqsURspS+4z4SSVNIAmBuHtP6v/K/2LKn8knwwUwqSSb0xKsFLr
   TlLRBsT0+DmnBLbhwMfbc41uj5+NMLuY2lwYEXhfklSQfW9C7FwINn3e9
   uGEgw55HJpF7uoY9YsBxHQzmTl5mZ7mB3/NUmGqVFL4R/o+7l0BLzU1QR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="398767160"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="398767160"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="702769368"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="702769368"
Received: from ake-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.189.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:48 -0800
From:   Vishal Verma <vishal.l.verma@intel.com>
To:     <linux-acpi@vger.kernel.org>
Cc:     <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, liushixin2@huawei.com,
        Vishal Verma <vishal.l.verma@intel.com>,
        Chris Piper <chris.d.piper@intel.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for single-initiator systems
Date:   Wed, 16 Nov 2022 00:57:36 -0700
Message-Id: <20221116075736.1909690-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116075736.1909690-1-vishal.l.verma@intel.com>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3279; h=from:subject; bh=verj7hVUBInaUTF3sejWeZjrgjgv2y6v3Lf9mbwz5Qg=; b=owGbwMvMwCXGf25diOft7jLG02pJDMkl0z9svJ/buO2c3Rtu9enxRRNuzgtbEmQ67VaDm8jbhSIb 5/RP7ShlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBECqIY/vs7MtucytbScuKRXbFYMr ro6v09R37KLFjgFX8/0Z2j8AnDH47sSynStb89puWtldx+bNK/fQLWPxZavtp/xEj2bdZzRjYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Add a new helper to sort the initiator list, and handle the singular
list corner case by setting the node mask for that explicitly.

Reported-by: Chris Piper <chris.d.piper@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/numa/hmat.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 144a84f429ed..cd20b0e9cdfa 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -573,6 +573,30 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	/*
+	 * list_sort doesn't call @cmp (initiator_cmp) for 0 or 1 sized lists.
+	 * For a single-initiator system with other memory-only nodes, this
+	 * means an empty p_nodes mask, since that is set by initiator_cmp().
+	 * Special case the singular list, and make sure the node mask gets set
+	 * appropriately.
+	 */
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	if (list_is_singular(&initiators)) {
+		struct memory_initiator *initiator = list_first_entry(
+			&initiators, struct memory_initiator, node);
+
+		set_bit(initiator->processor_pxm, p_nodes);
+		return 0;
+	}
+
+	list_sort(p_nodes, &initiators, initiator_cmp);
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -609,7 +633,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -643,7 +669,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
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
2.38.1

