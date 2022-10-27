Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A4560FEE7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiJ0RJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiJ0RJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0F42EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B401FB825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228D7C433D6;
        Thu, 27 Oct 2022 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890566;
        bh=cDbT+akTIhFkzCDvj0jjQMcj6046ZfjuEwH2MgofU/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd1v0+lthDblx/O8aOCd5IC7tnlDdk9tAwPftOuzzNvP5xfCIhRSNbKk9PEp7Inwt
         zBOu5t/uG9slt3gWMSZ6xMhch0jNhJ3lMCB71fmeM2Lvqt6KvFJMg8pGU0IZpCwenx
         aJsycn7zWrr3K+FxHMetTeTeYBnYG9AW01G0bdug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/53] ACPI: extlog: Handle multiple records
Date:   Thu, 27 Oct 2022 18:56:27 +0200
Message-Id: <20221027165051.316847792@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit f6ec01da40e4139b41179f046044ee7c4f6370dc ]

If there is no user space consumer of extlog_mem trace records, then
Linux properly handles multiple error records in an ELOG block

	extlog_print()
	  print_extlog_rcd()
	    __print_extlog_rcd()
	      cper_estatus_print()
		apei_estatus_for_each_section()

But the other code path hard codes looking for a single record to
output a trace record.

Fix by using the same apei_estatus_for_each_section() iterator
to step over all records.

Fixes: 2dfb7d51a61d ("trace, RAS: Add eMCA trace event interface")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 91d0b0fc392b..4c05c3828c9e 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -140,8 +141,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -162,17 +163,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	/* log event via trace */
 	err_seq++;
-	gdata = (struct acpi_hest_generic_data *)(tmp + 1);
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
-		fru_id = (guid_t *)gdata->fru_id;
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
-		fru_text = gdata->fru_text;
-	sec_type = (guid_t *)gdata->section_type;
-	if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
-		if (gdata->error_data_length >= sizeof(*mem))
-			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
-					       (u8)gdata->error_severity);
+	apei_estatus_for_each_section(tmp, gdata) {
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (guid_t *)gdata->fru_id;
+		else
+			fru_id = &guid_null;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+		else
+			fru_text = "";
+		sec_type = (guid_t *)gdata->section_type;
+		if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
+			struct cper_sec_mem_err *mem = (void *)(gdata + 1);
+
+			if (gdata->error_data_length >= sizeof(*mem))
+				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+						       (u8)gdata->error_severity);
+		}
 	}
 
 out:
-- 
2.35.1



