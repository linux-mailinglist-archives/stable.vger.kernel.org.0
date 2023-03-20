Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D486C197F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjCTPeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjCTPdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B715126DB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B93D2B80ED7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1E8C433D2;
        Mon, 20 Mar 2023 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326000;
        bh=ZGs7l5Ud+ipwYBmxK3XJqmyjDv9jr2SVhfE3o9Fp42E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNEWs9yH77ueoNbh4kxdcozVPFNmPlMSeVJFlGm/2CYKYDtFDQdoa6rYscd/XyWAL
         c4LcNrrz0oOm9DvcSt8x9yPkT40JDQOMR6/PnwOfnpEQK+5ss/4Uo7+FQi229QJ+cV
         cW5iheDXqUonSgj3yP2w7+jbcpRGkXApqxsW2GqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aishwarya TCV <aishwarya.tcv@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Pierre Gondois <pierre.gondois@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 181/198] ACPI: PPTT: Fix to avoid sleep in the atomic context when PPTT is absent
Date:   Mon, 20 Mar 2023 15:55:19 +0100
Message-Id: <20230320145515.078459248@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

commit 91d7b60a65d9f71230ea09b86d2058a884a3c2af upstream.

Commit 0c80f9e165f8 ("ACPI: PPTT: Leave the table mapped for the runtime usage")
enabled to map PPTT once on the first invocation of acpi_get_pptt() and
never unmapped the same allowing it to be used at runtime with out the
hassle of mapping and unmapping the table. This was needed to fetch LLC
information from the PPTT in the cpuhotplug path which is executed in
the atomic context as the acpi_get_table() might sleep waiting for a
mutex.

However it missed to handle the case when there is no PPTT on the system
which results in acpi_get_pptt() being called from all the secondary
CPUs attempting to fetch the LLC information in the atomic context
without knowing the absence of PPTT resulting in the splat like below:

 | BUG: sleeping function called from invalid context at kernel/locking/semaphore.c:164
 | in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
 | preempt_count: 1, expected: 0
 | RCU nest depth: 0, expected: 0
 | no locks held by swapper/1/0.
 | irq event stamp: 0
 | hardirqs last  enabled at (0): 0x0
 | hardirqs last disabled at (0): copy_process+0x61c/0x1b40
 | softirqs last  enabled at (0): copy_process+0x61c/0x1b40
 | softirqs last disabled at (0): 0x0
 | CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.3.0-rc1 #1
 | Call trace:
 |  dump_backtrace+0xac/0x138
 |  show_stack+0x30/0x48
 |  dump_stack_lvl+0x60/0xb0
 |  dump_stack+0x18/0x28
 |  __might_resched+0x160/0x270
 |  __might_sleep+0x58/0xb0
 |  down_timeout+0x34/0x98
 |  acpi_os_wait_semaphore+0x7c/0xc0
 |  acpi_ut_acquire_mutex+0x58/0x108
 |  acpi_get_table+0x40/0xe8
 |  acpi_get_pptt+0x48/0xa0
 |  acpi_get_cache_info+0x38/0x140
 |  init_cache_level+0xf4/0x118
 |  detect_cache_attributes+0x2e4/0x640
 |  update_siblings_masks+0x3c/0x330
 |  store_cpu_topology+0x88/0xf0
 |  secondary_start_kernel+0xd0/0x168
 |  __secondary_switched+0xb8/0xc0

Update acpi_get_pptt() to consider the fact that PPTT is once checked and
is not available on the system and return NULL avoiding any attempts to
fetch PPTT and thereby avoiding any possible sleep waiting for a mutex
in the atomic context.

Fixes: 0c80f9e165f8 ("ACPI: PPTT: Leave the table mapped for the runtime usage")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Pierre Gondois <pierre.gondois@arm.com>
Cc: 6.0+ <stable@vger.kernel.org> # 6.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pptt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -537,16 +537,19 @@ static int topology_get_acpi_cpu_tag(str
 static struct acpi_table_header *acpi_get_pptt(void)
 {
 	static struct acpi_table_header *pptt;
+	static bool is_pptt_checked;
 	acpi_status status;
 
 	/*
 	 * PPTT will be used at runtime on every CPU hotplug in path, so we
 	 * don't need to call acpi_put_table() to release the table mapping.
 	 */
-	if (!pptt) {
+	if (!pptt && !is_pptt_checked) {
 		status = acpi_get_table(ACPI_SIG_PPTT, 0, &pptt);
 		if (ACPI_FAILURE(status))
 			acpi_pptt_warn_missing();
+
+		is_pptt_checked = true;
 	}
 
 	return pptt;


