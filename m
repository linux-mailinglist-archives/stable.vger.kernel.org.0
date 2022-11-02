Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78F615A40
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKBD1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiKBD1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B7525EBF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54B0FB82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3860BC433D6;
        Wed,  2 Nov 2022 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359662;
        bh=yWjvjiQRi+6N1F9RucyPok34JUDZXBqiUoAckQcTlSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2N1ESgpoKPyUTpCwrupqcW3pMBHJnk8Ia6x9gEqcN5L05v3KsZ1TxHStZMLeAd7+
         4JPgG9uc20gA+0LAEXVf4nx7bh1eWFowu8itoZhAw+9VU7GkI6Ih84PcJbEwRVHwvc
         y019N2MQjNSHzAlG9C8asxXIL4+lNVt/v6e2Fm/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/78] ACPI: extlog: Handle multiple records
Date:   Wed,  2 Nov 2022 03:33:58 +0100
Message-Id: <20221102022053.331037781@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 943b1dc2d0b3..e05309bc41cc 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -13,6 +13,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -141,8 +142,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -163,17 +164,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
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



