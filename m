Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FBF6DEF68
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjDLIul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDLIuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC9E976A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A187B63172
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C55C4339B;
        Wed, 12 Apr 2023 08:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289413;
        bh=VNoa/RGHMVWGj69YpT8U/IOouX9L85GcZPpF2qzZjS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F7KkZYoAk+iR94j9zAXmRSTbR8K3W30ojZAIjGO7iLyjnBPDSTF3WFiOJjeAO1Bn
         h9N+7j/cLvhHFVwSW+mk+uW/+i3tY+KLZBAgFK6p2ljvGizlN3F2Hoicv5A408wIw/
         /evGmHnalPiZTofxjylMy4mDMiNd8lJqUaMa7vgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gregory Price <gregory.price@memverge.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.2 059/173] PCI/DOE: Silence WARN splat with CONFIG_DEBUG_OBJECTS=y
Date:   Wed, 12 Apr 2023 10:33:05 +0200
Message-Id: <20230412082840.492937638@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 92dc899c3b4927f3cfa23f55bf759171234b5802 upstream.

Gregory Price reports a WARN splat with CONFIG_DEBUG_OBJECTS=y upon CXL
probing because pci_doe_submit_task() invokes INIT_WORK() instead of
INIT_WORK_ONSTACK() for a work_struct that was allocated on the stack.

All callers of pci_doe_submit_task() allocate the work_struct on the
stack, so replace INIT_WORK() with INIT_WORK_ONSTACK() as a backportable
short-term fix.

The long-term fix implemented by a subsequent commit is to move to a
synchronous API which allocates the work_struct internally in the DOE
library.

Stacktrace for posterity:

WARNING: CPU: 0 PID: 23 at lib/debugobjects.c:545 __debug_object_init.cold+0x18/0x183
CPU: 0 PID: 23 Comm: kworker/u2:1 Not tainted 6.1.0-0.rc1.20221019gitaae703b02f92.17.fc38.x86_64 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Call Trace:
 pci_doe_submit_task+0x5d/0xd0
 pci_doe_discovery+0xb4/0x100
 pcim_doe_create_mb+0x219/0x290
 cxl_pci_probe+0x192/0x430
 local_pci_probe+0x41/0x80
 pci_device_probe+0xb3/0x220
 really_probe+0xde/0x380
 __driver_probe_device+0x78/0x170
 driver_probe_device+0x1f/0x90
 __driver_attach_async_helper+0x5c/0xe0
 async_run_entry_fn+0x30/0x130
 process_one_work+0x294/0x5b0

Fixes: 9d24322e887b ("PCI/DOE: Add DOE mailbox support functions")
Link: https://lore.kernel.org/linux-cxl/Y1bOniJliOFszvIK@memverge.com/
Reported-by: Gregory Price <gregory.price@memverge.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Gregory Price <gregory.price@memverge.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Gregory Price <gregory.price@memverge.com>
Cc: stable@vger.kernel.org # v6.0+
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/67a9117f463ecdb38a2dbca6a20391ce2f1e7a06.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/doe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -523,6 +523,8 @@ EXPORT_SYMBOL_GPL(pci_doe_supports_prot)
  * task->complete will be called when the state machine is done processing this
  * task.
  *
+ * @task must be allocated on the stack.
+ *
  * Excess data will be discarded.
  *
  * RETURNS: 0 when task has been successfully queued, -ERRNO on error
@@ -544,7 +546,7 @@ int pci_doe_submit_task(struct pci_doe_m
 		return -EIO;
 
 	task->doe_mb = doe_mb;
-	INIT_WORK(&task->work, doe_statemachine_work);
+	INIT_WORK_ONSTACK(&task->work, doe_statemachine_work);
 	queue_work(doe_mb->work_queue, &task->work);
 	return 0;
 }


