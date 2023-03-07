Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F066AF290
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjCGSyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjCGSxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:53:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E63C2215
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 105F36150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA5C433D2;
        Tue,  7 Mar 2023 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214495;
        bh=x08unpFatYDWZt7imy+kG51V/+gZD9eU+7ea8yK8q8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fazuHqgxpcruhJowrZlIh2yPVL/OU/qvd/+E6fqr/1Oc3gT+3IP91k3enqKuwWzG4
         /r8Oq/yU4wDUuny4zYzIr+R8nB57Owm7fnBRpBVJTRHlpkNW07xiYjB56srbscYt98
         k/njDz6vu67K6EbK1PUUwa6zM80sWJOtjqewt818=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Fagnani <matt.fagnani@bell.net>,
        Joerg Roedel <joro@8bytes.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 842/885] iommu/amd: Improve page fault error reporting
Date:   Tue,  7 Mar 2023 18:02:56 +0100
Message-Id: <20230307170038.408082592@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasant Hegde <vasant.hegde@amd.com>

commit 996d120b4de2b0d6b592bd9fbbe6e244b81ab3cc upstream.

If IOMMU domain for device group is not setup properly then we may hit
IOMMU page fault. Current page fault handler assumes that domain is
always setup and it will hit NULL pointer derefence (see below sample log).

Lets check whether domain is setup or not and log appropriate message.

Sample log:
----------
 amdgpu 0000:00:01.0: amdgpu: SE 1, SH per SE 1, CU per SH 8, active_cu_number 6
 BUG: kernel NULL pointer dereference, address: 0000000000000058
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 2 PID: 56 Comm: irq/24-AMD-Vi Not tainted 6.2.0-rc2+ #89
 Hardware name: xxx
 RIP: 0010:report_iommu_fault+0x11/0x90
 [...]
 Call Trace:
  <TASK>
  amd_iommu_int_thread+0x60c/0x760
  ? __pfx_irq_thread_fn+0x10/0x10
  irq_thread_fn+0x1f/0x60
  irq_thread+0xea/0x1a0
  ? preempt_count_add+0x6a/0xa0
  ? __pfx_irq_thread_dtor+0x10/0x10
  ? __pfx_irq_thread+0x10/0x10
  kthread+0xe9/0x110
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x2c/0x50
  </TASK>

Reported-by: Matt Fagnani <matt.fagnani@bell.net>
Suggested-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216865
Link: https://lore.kernel.org/lkml/15d0f9ff-2a56-b3e9-5b45-e6b23300ae3b@leemhuis.info/
Link: https://lore.kernel.org/r/20230215052642.6016-3-vasant.hegde@amd.com
Cc: stable@vger.kernel.org
[joro: Edit commit message]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -558,6 +558,15 @@ static void amd_iommu_report_page_fault(
 		 * prevent logging it.
 		 */
 		if (IS_IOMMU_MEM_TRANSACTION(flags)) {
+			/* Device not attached to domain properly */
+			if (dev_data->domain == NULL) {
+				pr_err_ratelimited("Event logged [Device not attached to domain properly]\n");
+				pr_err_ratelimited("  device=%04x:%02x:%02x.%x domain=0x%04x\n",
+						   iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid),
+						   PCI_FUNC(devid), domain_id);
+				goto out;
+			}
+
 			if (!report_iommu_fault(&dev_data->domain->domain,
 						&pdev->dev, address,
 						IS_WRITE_REQUEST(flags) ?


