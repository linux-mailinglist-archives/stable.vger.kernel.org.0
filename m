Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727D862CEEF
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 00:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiKPXmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 18:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbiKPXmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 18:42:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C56DCC5;
        Wed, 16 Nov 2022 15:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642089; x=1700178089;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to;
  bh=453B5mw51T7IX+AXE0lYBsFPvcN1QxhgkLQ4Y5mYFRM=;
  b=OKZRT9+IUlLsVXavPhIOWtmaZl6HZv+qd3K0K9ReCmJ0sMzHtHW/kwHU
   zXgMUe8dRQPDOmGWLeZcLNpD0MSrgXzW45ysdOUGnLTy7BI+Mn9lj7dsg
   lZrH7lBreqGz7L6WYTW2Bn5ElW/x2K5R2iEf6hmNvduKQ3sv2P8LKIgdr
   nrBomr0NSl9RkXr38lcdbpWNe3GVgKyrIvf+twK9SqBuOkvZ537m+EAhE
   eOn9W4JhUReQrX+JR4cUob6WVqCugTgPJ82HXd5bDg+t8vlaNGYklxhBQ
   mgCRxHx/LY6tb5+6esejV4rdc9AVhr811HJ5BYo/c6GLhxAIYZ0sVZirT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="292405781"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="292405781"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641848525"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641848525"
Received: from jjeyaram-mobl1.amr.corp.intel.com (HELO [192.168.1.28]) ([10.212.1.223])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
From:   Vishal Verma <vishal.l.verma@intel.com>
Date:   Wed, 16 Nov 2022 16:37:37 -0700
Subject: [PATCH v2 2/2] ACPI: HMAT: Fix initiator registration for single-initiator
 systems
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
In-Reply-To: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-kernel@vger.kernel.org,
        Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev,
        linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d1636
X-Developer-Signature: v=1; a=openpgp-sha256; l=3352;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=453B5mw51T7IX+AXE0lYBsFPvcN1QxhgkLQ4Y5mYFRM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmlpeqsYdp2c6xeZyWxh7anfNhvw1H+WbRO+Ayz2zwZr7Sk
 i787SlkYxLgYZMUUWf7u+ch4TG57Pk9ggiPMHFYmkCEMXJwCMJFb0gz/U172aH6qFWVgmvjmX+DGCo
 6b/u//7ddaqnris2xwmIJqOcM/s9eXn8WKzOXZu3v/G7uVJ4siwiUDNFq8lde3/XYJcs7nBgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/acpi/numa/hmat.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

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

-- 
2.38.1
