Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77FF1BFA68
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgD3NxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgD3NxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541F420873;
        Thu, 30 Apr 2020 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254791;
        bh=uYDz60v5LTGoxlNQT418XjQi9htRM1lYd0mtAyncrJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtytrcCoVrciyKu7G09rGICnkPoZyg4bJ2Oug1NPdooidfYzmUO/maMobuj2VgjDu
         8m1+KkHzm0OgTVrnY72ge9cAT7FngJXKk/w75fVtyTsrEQ8vFnqdaynAsc7qOvYxTa
         8Hmj1Zk1+TJEFnYzEGLESlgcrPPbzORxq48x1j3g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 47/57] tracing: Fix memory leaks in trace_events_hist.c
Date:   Thu, 30 Apr 2020 09:52:08 -0400
Message-Id: <20200430135218.20372-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

[ Upstream commit 9da73974eb9c965dd9989befb593b8c8da9e4bdc ]

kmemleak report 1:
    [<9092c50b>] kmem_cache_alloc_trace+0x138/0x270
    [<05a2c9ed>] create_field_var+0xcf/0x180
    [<528a2d68>] action_create+0xe2/0xc80
    [<63f50b61>] event_hist_trigger_func+0x15b5/0x1920
    [<28ea5d3d>] trigger_process_regex+0x7b/0xc0
    [<3138e86f>] event_trigger_write+0x4d/0xb0
    [<ffd66c19>] __vfs_write+0x30/0x200
    [<4f424a0d>] vfs_write+0x96/0x1b0
    [<da59a290>] ksys_write+0x53/0xc0
    [<3717101a>] __ia32_sys_write+0x15/0x20
    [<c5f23497>] do_fast_syscall_32+0x70/0x250
    [<46e2629c>] entry_SYSENTER_32+0xaf/0x102

This is because save_vars[] of struct hist_trigger_data are
not destroyed

kmemleak report 2:
    [<9092c50b>] kmem_cache_alloc_trace+0x138/0x270
    [<6e5e97c5>] create_var+0x3c/0x110
    [<de82f1b9>] create_field_var+0xaf/0x180
    [<528a2d68>] action_create+0xe2/0xc80
    [<63f50b61>] event_hist_trigger_func+0x15b5/0x1920
    [<28ea5d3d>] trigger_process_regex+0x7b/0xc0
    [<3138e86f>] event_trigger_write+0x4d/0xb0
    [<ffd66c19>] __vfs_write+0x30/0x200
    [<4f424a0d>] vfs_write+0x96/0x1b0
    [<da59a290>] ksys_write+0x53/0xc0
    [<3717101a>] __ia32_sys_write+0x15/0x20
    [<c5f23497>] do_fast_syscall_32+0x70/0x250
    [<46e2629c>] entry_SYSENTER_32+0xaf/0x102

struct hist_field allocated through create_var() do not initialize
"ref" field to 1. The code in __destroy_hist_field() does not destroy
object if "ref" is initialized to zero, the condition
if (--hist_field->ref > 1) always passes since unsigned int wraps.

kmemleak report 3:
    [<f8666fcc>] __kmalloc_track_caller+0x139/0x2b0
    [<bb7f80a5>] kstrdup+0x27/0x50
    [<39d70006>] init_var_ref+0x58/0xd0
    [<8ca76370>] create_var_ref+0x89/0xe0
    [<f045fc39>] action_create+0x38f/0xc80
    [<7c146821>] event_hist_trigger_func+0x15b5/0x1920
    [<07de3f61>] trigger_process_regex+0x7b/0xc0
    [<e87daf8f>] event_trigger_write+0x4d/0xb0
    [<19bf1512>] __vfs_write+0x30/0x200
    [<64ce4d27>] vfs_write+0x96/0x1b0
    [<a6f34170>] ksys_write+0x53/0xc0
    [<7d4230cd>] __ia32_sys_write+0x15/0x20
    [<8eadca00>] do_fast_syscall_32+0x70/0x250
    [<235cf985>] entry_SYSENTER_32+0xaf/0x102

hist_fields (system & event_name) are not freed

Link: http://lkml.kernel.org/r/20200422061503.GA5151@cosmos

Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 6495800fb92a1..8107574e8af9d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2466,6 +2466,9 @@ static void __destroy_hist_field(struct hist_field *hist_field)
 	kfree(hist_field->name);
 	kfree(hist_field->type);
 
+	kfree(hist_field->system);
+	kfree(hist_field->event_name);
+
 	kfree(hist_field);
 }
 
@@ -3528,6 +3531,7 @@ static struct hist_field *create_var(struct hist_trigger_data *hist_data,
 		goto out;
 	}
 
+	var->ref = 1;
 	var->flags = HIST_FIELD_FL_VAR;
 	var->var.idx = idx;
 	var->var.hist_data = var->hist_data = hist_data;
@@ -4157,6 +4161,9 @@ static void destroy_field_vars(struct hist_trigger_data *hist_data)
 
 	for (i = 0; i < hist_data->n_field_vars; i++)
 		destroy_field_var(hist_data->field_vars[i]);
+
+	for (i = 0; i < hist_data->n_save_vars; i++)
+		destroy_field_var(hist_data->save_vars[i]);
 }
 
 static void save_field_var(struct hist_trigger_data *hist_data,
-- 
2.20.1

