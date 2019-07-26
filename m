Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082BC7681A
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbfGZNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387897AbfGZNmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871A122CC2;
        Fri, 26 Jul 2019 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148536;
        bh=cK+4ZI7ONRMmofh2PiyzJkm+n+FSC2dB0tgVtk5lsF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3nDXRo/8q7DmvG9RzkqlRCiCmbJj0mXfPPcMGpWjMTULbRJMQ0ys1qDCsDbWw4bU
         GUrahRbbtu8xgwcAeMr2cvaHqk86Hb74Yq/arw0+uFXd5j4i3CPyISGLzIk/If9jAO
         /DyuFtljfr+kizw/3p6nUmASpRN6fQJT6VHTD5ms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cheng Jian <cj.chengjian@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 05/47] ftrace: Enable trampoline when rec count returns back to one
Date:   Fri, 26 Jul 2019 09:41:28 -0400
Message-Id: <20190726134210.12156-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134210.12156-1-sashal@kernel.org>
References: <20190726134210.12156-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Jian <cj.chengjian@huawei.com>

[ Upstream commit a124692b698b00026a58d89831ceda2331b2e1d0 ]

Custom trampolines can only be enabled if there is only a single ops
attached to it. If there's only a single callback registered to a function,
and the ops has a trampoline registered for it, then we can call the
trampoline directly. This is very useful for improving the performance of
ftrace and livepatch.

If more than one callback is registered to a function, the general
trampoline is used, and the custom trampoline is not restored back to the
direct call even if all the other callbacks were unregistered and we are
back to one callback for the function.

To fix this, set FTRACE_FL_TRAMP flag if rec count is decremented
to one, and the ops that left has a trampoline.

Testing After this patch :

insmod livepatch_unshare_files.ko
cat /sys/kernel/debug/tracing/enabled_functions

	unshare_files (1) R I	tramp: 0xffffffffc0000000(klp_ftrace_handler+0x0/0xa0) ->ftrace_ops_assist_func+0x0/0xf0

echo unshare_files > /sys/kernel/debug/tracing/set_ftrace_filter
echo function > /sys/kernel/debug/tracing/current_tracer
cat /sys/kernel/debug/tracing/enabled_functions

	unshare_files (2) R I ->ftrace_ops_list_func+0x0/0x150

echo nop > /sys/kernel/debug/tracing/current_tracer
cat /sys/kernel/debug/tracing/enabled_functions

	unshare_files (1) R I	tramp: 0xffffffffc0000000(klp_ftrace_handler+0x0/0xa0) ->ftrace_ops_assist_func+0x0/0xf0

Link: http://lkml.kernel.org/r/1556969979-111047-1-git-send-email-cj.chengjian@huawei.com

Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 118ecce14386..d9dd709b3c12 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1647,6 +1647,11 @@ static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
 	return  keep_regs;
 }
 
+static struct ftrace_ops *
+ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
+static struct ftrace_ops *
+ftrace_find_tramp_ops_next(struct dyn_ftrace *rec, struct ftrace_ops *ops);
+
 static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1775,15 +1780,17 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			}
 
 			/*
-			 * If the rec had TRAMP enabled, then it needs to
-			 * be cleared. As TRAMP can only be enabled iff
-			 * there is only a single ops attached to it.
-			 * In otherwords, always disable it on decrementing.
-			 * In the future, we may set it if rec count is
-			 * decremented to one, and the ops that is left
-			 * has a trampoline.
+			 * The TRAMP needs to be set only if rec count
+			 * is decremented to one, and the ops that is
+			 * left has a trampoline. As TRAMP can only be
+			 * enabled if there is only a single ops attached
+			 * to it.
 			 */
-			rec->flags &= ~FTRACE_FL_TRAMP;
+			if (ftrace_rec_count(rec) == 1 &&
+			    ftrace_find_tramp_ops_any(rec))
+				rec->flags |= FTRACE_FL_TRAMP;
+			else
+				rec->flags &= ~FTRACE_FL_TRAMP;
 
 			/*
 			 * flags will be cleared in ftrace_check_record()
@@ -1976,11 +1983,6 @@ static void print_ip_ins(const char *fmt, const unsigned char *p)
 		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
 }
 
-static struct ftrace_ops *
-ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
-static struct ftrace_ops *
-ftrace_find_tramp_ops_next(struct dyn_ftrace *rec, struct ftrace_ops *ops);
-
 enum ftrace_bug_type ftrace_bug_type;
 const void *ftrace_expected;
 
-- 
2.20.1

