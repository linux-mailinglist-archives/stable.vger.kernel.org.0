Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFC60FE1F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiJ0RCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiJ0RCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE33193745
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44512B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE55C433C1;
        Thu, 27 Oct 2022 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890132;
        bh=Ov4AyNc6DGU/isc+7CaCnVX4fnKqO2U7FUJBaUhTHD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPd2Gu62TxSD+ePFnXQ8HzzbnuBrd7O8BvQpoH5nM+YDXIPW4EEfozQnI5QBV2a2B
         pvXNffUXtRtefY/QRTQAeuIOZwuHYHoa1nMQcSEMD1JjL600YP1iFczh712V3drl7k
         1RPgIxhBEjXOvUheS8AoC6qnDEoMs7AUqtTwv+90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/79] ACPI: extlog: Handle multiple records
Date:   Thu, 27 Oct 2022 18:55:33 +0200
Message-Id: <20221027165056.102043833@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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
index 72f1fb77abcd..e648158368a7 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -138,8 +139,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -160,17 +161,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
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



