Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7005858DEFE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbiHIS3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347630AbiHIS1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC1C2A241;
        Tue,  9 Aug 2022 11:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEAF0B81919;
        Tue,  9 Aug 2022 18:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5CEC433B5;
        Tue,  9 Aug 2022 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068487;
        bh=aS6kC7/UR/+s4cEQ6IbqOtahiGkvu5P7CX0AzJ/IWIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hODm+WBOEiojscPOmrmPSZ5xJc2mA+nabE98myb8SMOB4YZ+/D8cA1ehnikyNgojz
         yMyWFHDC4YdlV1eedh7ziTdn3jF5ZSFGFAjxvKPq0Y3Wcod9Lobq+yfAGk7o4/CMPl
         cqWCDxrm253qrnXWcVLiGIT7jF5G3YXcTi39CW2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 05/21] ACPI: APEI: Better fix to avoid spamming the console with old error logs
Date:   Tue,  9 Aug 2022 20:00:57 +0200
Message-Id: <20220809175513.512663161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
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


