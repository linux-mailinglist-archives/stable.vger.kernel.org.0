Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E9566C6B5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjAPQXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjAPQXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:23:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1930C32E5E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99DAFB8108B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E681DC433F1;
        Mon, 16 Jan 2023 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885559;
        bh=Y1DO5o7BuAe5s+ybFJLesPQquWluBXAXBGwYrizFhzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/XTiElGQ1+Q9o2iF0wgDOEVo9nZpRQv29RJcfRd6iT4Qbd+azy30HaZkun62KeNw
         TDS5ekXxGmhx9ZCb5zAH3/u/iXhMjZgn22Q73MOyqczSQhv7RW8VhRSSyIHfok3oIo
         Iaf45mOzhqxfNZXvGkEcORPMf+7CoPnB2gd5A6y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Liao <liaoyu15@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/658] platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()
Date:   Mon, 16 Jan 2023 16:42:58 +0100
Message-Id: <20230116154913.681402971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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



