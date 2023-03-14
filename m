Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7046B94CC
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjCNMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjCNMsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB3CA4027;
        Tue, 14 Mar 2023 05:45:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A53C61785;
        Tue, 14 Mar 2023 12:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A76C433A1;
        Tue, 14 Mar 2023 12:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797862;
        bh=6mnJ02aYnibZUK89exexsNsvgLET+QSfQH75tsMeHe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYtJblLL9ZWkQ3jln+IpmmEgQ/0i1OkDBOCbYCY+/mLnLl3yD1YZj0z4Idl4wqcty
         blEmvy2Upv5BEEQlv3KTzuOLe43a8DYsF1VOx1GIecHKmuAswVmKRz9kK+Sf3ppxId
         9kK5pikKpMQ6ZElQE/ngJUZa95gKsyN96XYkfttUBhZl34uLFwSNrULqBNNH61YITD
         6zCZ7ol7nacRCwZ/MtIM+1ssUIayCH6HdFXXEVJ1iVsL6swMti0YTS+vAwLntxs4Rh
         oEcfIOF0eWB1X0XETXnR57qcJpCMmwWWyqLdJB7Kri9v1C6H8Y432bKmgCQvFXNxUB
         dGq/VghbsgZrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Huang <qu.huang@linux.dev>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, oded.gabbay@gmail.com,
        christian.koenig@amd.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 6/7] drm/amdkfd: Fix an illegal memory access
Date:   Tue, 14 Mar 2023 08:44:11 -0400
Message-Id: <20230314124412.471364-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124412.471364-1-sashal@kernel.org>
References: <20230314124412.471364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index adbb2fec2e0f2..4fd7dcef2e382 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -529,16 +529,13 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
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

