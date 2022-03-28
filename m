Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17D14E93DE
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiC1LZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbiC1LYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB9B554B0;
        Mon, 28 Mar 2022 04:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B22761192;
        Mon, 28 Mar 2022 11:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB57C340EC;
        Mon, 28 Mar 2022 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466473;
        bh=dXFoBao1mnO+CxBybDVWep7qs/QLa3ksJJVYsnYonhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/jExj6Th7zR4nsQLQPOC1pStCvzmXe2yu6LwBTrNlY74e/iyxIj1XRu0X5XLbqKj
         QnoUyvfBdm6MfZcqBOlQsjATgQNnglXudCZwQA4b5FAVSA7T1TStlzA4mWY+Q+YEex
         TbSRbAYao02LOd2eaauYZ32TdALLlXcaSkzpVbamQVVXmRVz4K6i+B+saCWU1NzLQ9
         N6hKnRB3Rml/r5Z4yC6Oz+hR+4kmyOBUj7orn6LfU6dy7rhHV6F/CVjNdULpH64+2m
         5BvmwLnXL/F98snE6jEKz9rJfTt3dc/qO5j5LaleJM3cjavrEcJuhq72w9c5poCggx
         hWeBcgoKRrOEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        rdunlap@infradead.org, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 28/35] ACPI/APEI: Limit printable size of BERT table data
Date:   Mon, 28 Mar 2022 07:20:04 -0400
Message-Id: <20220328112011.1555169-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Darren Hart <darren@os.amperecomputing.com>

[ Upstream commit 3f8dec116210ca649163574ed5f8df1e3b837d07 ]

Platforms with large BERT table data can trigger soft lockup errors
while attempting to print the entire BERT table data to the console at
boot:

  watchdog: BUG: soft lockup - CPU#160 stuck for 23s! [swapper/0:1]

Observed on Ampere Altra systems with a single BERT record of ~250KB.

The original bert driver appears to have assumed relatively small table
data. Since it is impractical to reassemble large table data from
interwoven console messages, and the table data is available in

  /sys/firmware/acpi/tables/data/BERT

limit the size for tables printed to the console to 1024 (for no reason
other than it seemed like a good place to kick off the discussion, would
appreciate feedback from existing users in terms of what size would
maintain their current usage model).

Alternatively, we could make printing a CONFIG option, use the
bert_disable boot arg (or something similar), or use a debug log level.
However, all those solutions require extra steps or change the existing
behavior for small table data. Limiting the size preserves existing
behavior on existing platforms with small table data, and eliminates the
soft lockups for platforms with large table data, while still making it
available.

Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/bert.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 19e50fcbf4d6..ad8ab3f12cf3 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -29,6 +29,7 @@
 
 #undef pr_fmt
 #define pr_fmt(fmt) "BERT: " fmt
+#define ACPI_BERT_PRINT_MAX_LEN 1024
 
 static int bert_disable;
 
@@ -58,8 +59,11 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		}
 
 		pr_info_once("Error records from previous boot:\n");
-
-		cper_estatus_print(KERN_INFO HW_ERR, estatus);
+		if (region_len < ACPI_BERT_PRINT_MAX_LEN)
+			cper_estatus_print(KERN_INFO HW_ERR, estatus);
+		else
+			pr_info_once("Max print length exceeded, table data is available at:\n"
+				     "/sys/firmware/acpi/tables/data/BERT");
 
 		/*
 		 * Because the boot error source is "one-time polled" type,
-- 
2.34.1

