Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB36089BE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiJVIkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiJVIkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7121E3915;
        Sat, 22 Oct 2022 01:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3776B82E1A;
        Sat, 22 Oct 2022 07:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D2CC433C1;
        Sat, 22 Oct 2022 07:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425539;
        bh=gQ9uhgSJYlR3is3lDutdEcOjJQsBHpKOa3lCfgM3yUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCD8WB7+fqOK3GrNJdwitp5+d3QVNS42LNaXx6LEn0pN4J3lUkrfIFB/VUIL0fvf2
         ZEl/NaG5Z2cdZ7IjEHEiJIFk/u0EgzfyIhYNYPRyrDtSQd0cl0F6aKPGHDR2Tiq9Sy
         iBjRwy/EcAIfg68Zapur010yXAqrYgGKJIriMhEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuai Xue <xueshuai@linux.alibaba.com>,
        Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 535/717] ACPI: APEI: do not add task_work to kernel thread to avoid memory leak
Date:   Sat, 22 Oct 2022 09:26:54 +0200
Message-Id: <20221022072521.984264440@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 415fed694fe11395df56e05022d6e7cee1d39dd3 ]

If an error is detected as a result of user-space process accessing a
corrupt memory location, the CPU may take an abort. Then the platform
firmware reports kernel via NMI like notifications, e.g. NOTIFY_SEA,
NOTIFY_SOFTWARE_DELEGATED, etc.

For NMI like notifications, commit 7f17b4a121d0 ("ACPI: APEI: Kick the
memory_failure() queue for synchronous errors") keep track of whether
memory_failure() work was queued, and make task_work pending to flush out
the queue so that the work is processed before return to user-space.

The code use init_mm to check whether the error occurs in user space:

    if (current->mm != &init_mm)

The condition is always true, becase _nobody_ ever has "init_mm" as a real
VM any more.

In addition to abort, errors can also be signaled as asynchronous
exceptions, such as interrupt and SError. In such case, the interrupted
current process could be any kind of thread. When a kernel thread is
interrupted, the work ghes_kick_task_work deferred to task_work will never
be processed because entry_handler returns to call ret_to_kernel() instead
of ret_to_user(). Consequently, the estatus_node alloced from
ghes_estatus_pool in ghes_in_nmi_queue_one_entry() will not be freed.
After around 200 allocations in our platform, the ghes_estatus_pool will
run of memory and ghes_in_nmi_queue_one_entry() returns ENOMEM. As a
result, the event failed to be processed.

    sdei: event 805 on CPU 113 failed with error: -2

Finally, a lot of unhandled events may cause platform firmware to exceed
some threshold and reboot.

The condition should generally just do

    if (current->mm)

as described in active_mm.rst documentation.

Then if an asynchronous error is detected when a kernel thread is running,
(e.g. when detected by a background scrubber), do not add task_work to it
as the original patch intends to do.

Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d91ad378c00d..80ad530583c9 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -985,7 +985,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 				ghes_estatus_cache_add(generic, estatus);
 		}
 
-		if (task_work_pending && current->mm != &init_mm) {
+		if (task_work_pending && current->mm) {
 			estatus_node->task_work.func = ghes_kick_task_work;
 			estatus_node->task_work_cpu = smp_processor_id();
 			ret = task_work_add(current, &estatus_node->task_work,
-- 
2.35.1



