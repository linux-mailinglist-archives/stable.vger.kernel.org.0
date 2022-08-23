Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6B59E30B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355903AbiHWKsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355598AbiHWKnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:43:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413374BB6;
        Tue, 23 Aug 2022 02:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62D81B81C4E;
        Tue, 23 Aug 2022 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C83C433D7;
        Tue, 23 Aug 2022 09:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245825;
        bh=gmvdW3wPd9G0O8DYp9xNM6Xhq5HzkLbnYLkfmeqK8aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LolUBoTPnLwKDPHcUkRj43VcVihyVe0Fcde1DUb2BH5+wNldA7RKXuF00qv7zRD5q
         R6X0uORSwmsyvfNoPeRuojb8X/wT1IjpblDi+WCr5AdPE4/hMxLVaC3qxUajFKX3Td
         ESsnRdizbNyGtUVk5qQhsPxsLprFlVtejoYCqEqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 200/287] ACPI: CPPC: Do not prevent CPPC from working in the future
Date:   Tue, 23 Aug 2022 10:26:09 +0200
Message-Id: <20220823080107.590260014@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 4f4179fcf420873002035cf1941d844c9e0e7cb3 upstream.

There is a problem with the current revision checks in
is_cppc_supported() that they essentially prevent the CPPC support
from working if a new _CPC package format revision being a proper
superset of the v3 and only causing _CPC to return a package with more
entries (while retaining the types and meaning of the entries defined by
the v3) is introduced in the future and used by the platform firmware.

In that case, as long as the number of entries in the _CPC return
package is at least CPPC_V3_NUM_ENT, it should be perfectly fine to
use the v3 support code and disregard the additional package entries
added by the new package format revision.

For this reason, drop is_cppc_supported() altogether, put the revision
checks directly into acpi_cppc_processor_probe() so they are easier to
follow and rework them to take the case mentioned above into account.

Fixes: 4773e77cdc9b ("ACPI / CPPC: Add support for CPPC v3")
Cc: 4.18+ <stable@vger.kernel.org> # 4.18+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |   54 ++++++++++++++++++++---------------------------
 include/acpi/cppc_acpi.h |    2 -
 2 files changed, 25 insertions(+), 31 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -630,33 +630,6 @@ int pcc_data_alloc(int pcc_ss_id)
 	return 0;
 }
 
-/* Check if CPPC revision + num_ent combination is supported */
-static bool is_cppc_supported(int revision, int num_ent)
-{
-	int expected_num_ent;
-
-	switch (revision) {
-	case CPPC_V2_REV:
-		expected_num_ent = CPPC_V2_NUM_ENT;
-		break;
-	case CPPC_V3_REV:
-		expected_num_ent = CPPC_V3_NUM_ENT;
-		break;
-	default:
-		pr_debug("Firmware exports unsupported CPPC revision: %d\n",
-			revision);
-		return false;
-	}
-
-	if (expected_num_ent != num_ent) {
-		pr_debug("Firmware exports %d entries. Expected: %d for CPPC rev:%d\n",
-			num_ent, expected_num_ent, revision);
-		return false;
-	}
-
-	return true;
-}
-
 /*
  * An example CPC table looks like the following.
  *
@@ -752,7 +725,6 @@ int acpi_cppc_processor_probe(struct acp
 				cpc_obj->type);
 		goto out_free;
 	}
-	cpc_ptr->num_entries = num_ent;
 
 	/* Second entry should be revision. */
 	cpc_obj = &out_obj->package.elements[1];
@@ -763,10 +735,32 @@ int acpi_cppc_processor_probe(struct acp
 				cpc_obj->type);
 		goto out_free;
 	}
-	cpc_ptr->version = cpc_rev;
 
-	if (!is_cppc_supported(cpc_rev, num_ent))
+	if (cpc_rev < CPPC_V2_REV) {
+		pr_debug("Unsupported _CPC Revision (%d) for CPU:%d\n", cpc_rev,
+			 pr->id);
 		goto out_free;
+	}
+
+	/*
+	 * Disregard _CPC if the number of entries in the return pachage is not
+	 * as expected, but support future revisions being proper supersets of
+	 * the v3 and only causing more entries to be returned by _CPC.
+	 */
+	if ((cpc_rev == CPPC_V2_REV && num_ent != CPPC_V2_NUM_ENT) ||
+	    (cpc_rev == CPPC_V3_REV && num_ent != CPPC_V3_NUM_ENT) ||
+	    (cpc_rev > CPPC_V3_REV && num_ent <= CPPC_V3_NUM_ENT)) {
+		pr_debug("Unexpected number of _CPC return package entries (%d) for CPU:%d\n",
+			 num_ent, pr->id);
+		goto out_free;
+	}
+	if (cpc_rev > CPPC_V3_REV) {
+		num_ent = CPPC_V3_NUM_ENT;
+		cpc_rev = CPPC_V3_REV;
+	}
+
+	cpc_ptr->num_entries = num_ent;
+	cpc_ptr->version = cpc_rev;
 
 	/* Iterate through remaining entries in _CPC */
 	for (i = 2; i < num_ent; i++) {
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -20,7 +20,7 @@
 #include <acpi/pcc.h>
 #include <acpi/processor.h>
 
-/* Support CPPCv2 and CPPCv3  */
+/* CPPCv2 and CPPCv3 support */
 #define CPPC_V2_REV	2
 #define CPPC_V3_REV	3
 #define CPPC_V2_NUM_ENT	21


