Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4094E4637B5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbhK3Ozg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58132 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242543AbhK3Oxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F583CE1A5B;
        Tue, 30 Nov 2021 14:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847BBC53FCD;
        Tue, 30 Nov 2021 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283817;
        bh=zxBJljs7e23+XZomIM7RI2roqvd+GMCfR/TzbPr+C60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAATUUS0rab94SV43r+lk4HMp6vOMBAw/akMFMDsCqw3sSaq/uiZyvFIRefjiEB+l
         Xlk/OICNF+VhGstrffZw7VsE3uWvhzhrVIha0ZK8gvj/RuGkJ1UxdXqI3JHKsLBi7t
         ux66vhzXZ1MYDkVbxboqngxyfqVwAU2uqkB1b4AKDy0WQs7TD5bi7Acgdmo5XYB5mD
         ZsSwIc+Wt+NHnTfKsVpT1az3ujTEc0lWVkmE/DMbsfzs//McH5GZ8dwPMGZ7nageEB
         wHRXwVzIgIRzqjW3T2bfqJzxGtnQQrs1LCVfoHViAZJtBa0NRJzw8vwQrBYlTxJHJp
         3V3YKwmDO1KlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 67/68] io_uring: Fix undefined-behaviour in io_issue_sqe
Date:   Tue, 30 Nov 2021 09:47:03 -0500
Message-Id: <20211130144707.944580-67-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit f6223ff799666235a80d05f8137b73e5580077b9 ]

We got issue as follows:
================================================================================
UBSAN: Undefined behaviour in ./include/linux/ktime.h:42:14
signed integer overflow:
-4966321760114568020 * 1000000000 cannot be represented in type 'long long int'
CPU: 1 PID: 2186 Comm: syz-executor.2 Not tainted 4.19.90+ #12
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x0/0x3f0 arch/arm64/kernel/time.c:78
 show_stack+0x28/0x38 arch/arm64/kernel/traps.c:158
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x170/0x1dc lib/dump_stack.c:118
 ubsan_epilogue+0x18/0xb4 lib/ubsan.c:161
 handle_overflow+0x188/0x1dc lib/ubsan.c:192
 __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
 ktime_set include/linux/ktime.h:42 [inline]
 timespec64_to_ktime include/linux/ktime.h:78 [inline]
 io_timeout fs/io_uring.c:5153 [inline]
 io_issue_sqe+0x42c8/0x4550 fs/io_uring.c:5599
 __io_queue_sqe+0x1b0/0xbc0 fs/io_uring.c:5988
 io_queue_sqe+0x1ac/0x248 fs/io_uring.c:6067
 io_submit_sqe fs/io_uring.c:6137 [inline]
 io_submit_sqes+0xed8/0x1c88 fs/io_uring.c:6331
 __do_sys_io_uring_enter fs/io_uring.c:8170 [inline]
 __se_sys_io_uring_enter fs/io_uring.c:8129 [inline]
 __arm64_sys_io_uring_enter+0x490/0x980 fs/io_uring.c:8129
 invoke_syscall arch/arm64/kernel/syscall.c:53 [inline]
 el0_svc_common+0x374/0x570 arch/arm64/kernel/syscall.c:121
 el0_svc_handler+0x190/0x260 arch/arm64/kernel/syscall.c:190
 el0_svc+0x10/0x218 arch/arm64/kernel/entry.S:1017
================================================================================

As ktime_set only judge 'secs' if big than KTIME_SEC_MAX, but if we pass
negative value maybe lead to overflow.
To address this issue, we must check if 'sec' is negative.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20211118015907.844807-1-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 365f8b350b7f0..d0933789bf3ce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6147,6 +6147,9 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
+	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
+		return -EINVAL;
+
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 
-- 
2.33.0

