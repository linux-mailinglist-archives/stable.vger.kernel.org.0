Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23BC58DE42
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345402AbiHISMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345304AbiHISKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:10:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864512A429;
        Tue,  9 Aug 2022 11:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E73661070;
        Tue,  9 Aug 2022 18:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFEAC433D7;
        Tue,  9 Aug 2022 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068255;
        bh=aS6kC7/UR/+s4cEQ6IbqOtahiGkvu5P7CX0AzJ/IWIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4Dq/Fv/FA/36WfBT0+Zm0Dlz7o3Oa0B95jUoBeEO/wYGjzsJn2y8uSo42YhzOeXo
         tCf5w4rfG8rI1albAn1ZxKBEw1soUcp3iOl3VG3bibi3Jmr2ZUsYGFsUKdv6lmb8iV
         CHaZFuLMMc8u24rgym2x6ZlKTbg4Hj8v9N2jg9r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 09/23] ACPI: APEI: Better fix to avoid spamming the console with old error logs
Date:   Tue,  9 Aug 2022 20:00:27 +0200
Message-Id: <20220809175513.207066218@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
References: <20220809175512.853274191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit c3481b6b75b4797657838f44028fd28226ab48e0 upstream.

The fix in commit 3f8dec116210 ("ACPI/APEI: Limit printable size of BERT
table data") does not work as intended on systems where the BIOS has a
fixed size block of memory for the BERT table, relying on s/w to quit
when it finds a record with estatus->block_status == 0. On these systems
all errors are suppressed because the check:

	if (region_len < ACPI_BERT_PRINT_MAX_LEN)

always fails.

New scheme skips individual CPER records that are too large, and also
limits the total number of records that will be printed to 5.

Fixes: 3f8dec116210 ("ACPI/APEI: Limit printable size of BERT table data")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/bert.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -29,16 +29,26 @@
 
 #undef pr_fmt
 #define pr_fmt(fmt) "BERT: " fmt
+
+#define ACPI_BERT_PRINT_MAX_RECORDS 5
 #define ACPI_BERT_PRINT_MAX_LEN 1024
 
 static int bert_disable;
 
+/*
+ * Print "all" the error records in the BERT table, but avoid huge spam to
+ * the console if the BIOS included oversize records, or too many records.
+ * Skipping some records here does not lose anything because the full
+ * data is available to user tools in:
+ *	/sys/firmware/acpi/tables/data/BERT
+ */
 static void __init bert_print_all(struct acpi_bert_region *region,
 				  unsigned int region_len)
 {
 	struct acpi_hest_generic_status *estatus =
 		(struct acpi_hest_generic_status *)region;
 	int remain = region_len;
+	int printed = 0, skipped = 0;
 	u32 estatus_len;
 
 	while (remain >= sizeof(struct acpi_bert_region)) {
@@ -46,24 +56,26 @@ static void __init bert_print_all(struct
 		if (remain < estatus_len) {
 			pr_err(FW_BUG "Truncated status block (length: %u).\n",
 			       estatus_len);
-			return;
+			break;
 		}
 
 		/* No more error records. */
 		if (!estatus->block_status)
-			return;
+			break;
 
 		if (cper_estatus_check(estatus)) {
 			pr_err(FW_BUG "Invalid error record.\n");
-			return;
+			break;
 		}
 
-		pr_info_once("Error records from previous boot:\n");
-		if (region_len < ACPI_BERT_PRINT_MAX_LEN)
+		if (estatus_len < ACPI_BERT_PRINT_MAX_LEN &&
+		    printed < ACPI_BERT_PRINT_MAX_RECORDS) {
+			pr_info_once("Error records from previous boot:\n");
 			cper_estatus_print(KERN_INFO HW_ERR, estatus);
-		else
-			pr_info_once("Max print length exceeded, table data is available at:\n"
-				     "/sys/firmware/acpi/tables/data/BERT");
+			printed++;
+		} else {
+			skipped++;
+		}
 
 		/*
 		 * Because the boot error source is "one-time polled" type,
@@ -75,6 +87,9 @@ static void __init bert_print_all(struct
 		estatus = (void *)estatus + estatus_len;
 		remain -= estatus_len;
 	}
+
+	if (skipped)
+		pr_info(HW_ERR "Skipped %d error records\n", skipped);
 }
 
 static int __init setup_bert_disable(char *str)


