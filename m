Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65946C170F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjCTPLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjCTPKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F21305C7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F116BB80ECD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B72DC433D2;
        Mon, 20 Mar 2023 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324763;
        bh=yJpAyWo/NF7iLqkVLMhZQxcFZmwikusnQXCzEy3Jnc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvHWclPrpumcdyYLzUE0R8vAioJk4SkRwdvCCGUATzUD3uUqUbK/Yg8r6Esdze/RP
         VmBb8A0CwTyYTz+q7I706aM9gRm5i1Z8uDwQyQwg99aRyjjAMBjETtW9Qy9GLfVjcw
         FMVtIJBp1QUNvyS5qx4JCRTLV1HIxd/MRMV1rYQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Huang <qu.huang@linux.dev>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/99] drm/amdkfd: Fix an illegal memory access
Date:   Mon, 20 Mar 2023 15:54:31 +0100
Message-Id: <20230320145445.608324758@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Huang <qu.huang@linux.dev>

[ Upstream commit 4fc8fff378b2f2039f2a666d9f8c570f4e58352c ]

In the kfd_wait_on_events() function, the kfd_event_waiter structure is
allocated by alloc_event_waiters(), but the event field of the waiter
structure is not initialized; When copy_from_user() fails in the
kfd_wait_on_events() function, it will enter exception handling to
release the previously allocated memory of the waiter structure;
Due to the event field of the waiters structure being accessed
in the free_waiters() function, this results in illegal memory access
and system crash, here is the crash log:

localhost kernel: RIP: 0010:native_queued_spin_lock_slowpath+0x185/0x1e0
localhost kernel: RSP: 0018:ffffaa53c362bd60 EFLAGS: 00010082
localhost kernel: RAX: ff3d3d6bff4007cb RBX: 0000000000000282 RCX: 00000000002c0000
localhost kernel: RDX: ffff9e855eeacb80 RSI: 000000000000279c RDI: ffffe7088f6a21d0
localhost kernel: RBP: ffffe7088f6a21d0 R08: 00000000002c0000 R09: ffffaa53c362be64
localhost kernel: R10: ffffaa53c362bbd8 R11: 0000000000000001 R12: 0000000000000002
localhost kernel: R13: ffff9e7ead15d600 R14: 0000000000000000 R15: ffff9e7ead15d698
localhost kernel: FS:  0000152a3d111700(0000) GS:ffff9e855ee80000(0000) knlGS:0000000000000000
localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
localhost kernel: CR2: 0000152938000010 CR3: 000000044d7a4000 CR4: 00000000003506e0
localhost kernel: Call Trace:
localhost kernel: _raw_spin_lock_irqsave+0x30/0x40
localhost kernel: remove_wait_queue+0x12/0x50
localhost kernel: kfd_wait_on_events+0x1b6/0x490 [hydcu]
localhost kernel: ? ftrace_graph_caller+0xa0/0xa0
localhost kernel: kfd_ioctl+0x38c/0x4a0 [hydcu]
localhost kernel: ? kfd_ioctl_set_trap_handler+0x70/0x70 [hydcu]
localhost kernel: ? kfd_ioctl_create_queue+0x5a0/0x5a0 [hydcu]
localhost kernel: ? ftrace_graph_caller+0xa0/0xa0
localhost kernel: __x64_sys_ioctl+0x8e/0xd0
localhost kernel: ? syscall_trace_enter.isra.18+0x143/0x1b0
localhost kernel: do_syscall_64+0x33/0x80
localhost kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
localhost kernel: RIP: 0033:0x152a4dff68d7

Allocate the structure with kcalloc, and remove redundant 0-initialization
and a redundant loop condition check.

Signed-off-by: Qu Huang <qu.huang@linux.dev>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 159be13ef20bb..2c19b3775179b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -528,16 +528,13 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	struct kfd_event_waiter *event_waiters;
 	uint32_t i;
 
-	event_waiters = kmalloc_array(num_events,
-					sizeof(struct kfd_event_waiter),
-					GFP_KERNEL);
+	event_waiters = kcalloc(num_events, sizeof(struct kfd_event_waiter),
+				GFP_KERNEL);
 	if (!event_waiters)
 		return NULL;
 
-	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
+	for (i = 0; i < num_events; i++)
 		init_wait(&event_waiters[i].wait);
-		event_waiters[i].activated = false;
-	}
 
 	return event_waiters;
 }
-- 
2.39.2



