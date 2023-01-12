Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4866744C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjALOEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjALODz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3625552C51
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBEE1B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FFBC433F1;
        Thu, 12 Jan 2023 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532231;
        bh=Y1DO5o7BuAe5s+ybFJLesPQquWluBXAXBGwYrizFhzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsUxgtWIcO8zrXR7Tn5dCdy4l3aReMzK/+GZvHqF6efe1ljNZ3fTWkWPRFcSuwYCV
         uBB0kYbS7M3oC1O/wYAH9k5DEBk7OxPT9f7MXt+od1tXqx4B1PgX6VyIL+dg7Jl9wJ
         7uwYP7FCcW1JRWsE1zueNsvYl5oOJaaZXfOlDtBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Liao <liaoyu15@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/783] platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()
Date:   Thu, 12 Jan 2023 14:46:49 +0100
Message-Id: <20230112135528.497087552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 727cc0147f5066e359aca65cc6cc5e6d64cc15d8 ]

The ACPI buffer memory (out.pointer) returned by wmi_evaluate_method()
is not freed after the call, so it leads to memory leak.

The method results in ACPI buffer is not used, so just pass NULL to
wmi_evaluate_method() which fixes the memory leak.

Fixes: 99b38b4acc0d ("platform/x86: add MXM WMI driver.")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Link: https://lore.kernel.org/r/20221129011101.2042315-1-liaoyu15@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mxm-wmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
index 9a19fbd2f734..9a457956025a 100644
--- a/drivers/platform/x86/mxm-wmi.c
+++ b/drivers/platform/x86/mxm-wmi.c
@@ -35,13 +35,11 @@ int mxm_wmi_call_mxds(int adapter)
 		.xarg = 1,
 	};
 	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 
 	printk("calling mux switch %d\n", adapter);
 
-	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input,
-				     &output);
+	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input, NULL);
 
 	if (ACPI_FAILURE(status))
 		return status;
@@ -60,13 +58,11 @@ int mxm_wmi_call_mxmx(int adapter)
 		.xarg = 1,
 	};
 	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 
 	printk("calling mux switch %d\n", adapter);
 
-	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input,
-				     &output);
+	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input, NULL);
 
 	if (ACPI_FAILURE(status))
 		return status;
-- 
2.35.1



