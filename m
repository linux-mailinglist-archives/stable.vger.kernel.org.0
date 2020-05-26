Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3441CACEF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgEHM5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbgEHMzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F3D24958;
        Fri,  8 May 2020 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942532;
        bh=iw4toVuYkRpmrlvVQJwhG1kN7mqnSLu2YFYTlvrElgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrID15648CohvfjPL77bGEZ2DwPUfmsRo7FGAtlj+nf/48wX67YhTofnjRtaLlnbi
         rhAZ/nluMZ4zKLXRKodyQWMpVAa2eDq74UG3r2/ONxFh0J3LmMsOllthgxgAiJY1wa
         p14q7/Sam8Pz9+klMJyYme7FiIn5SRVYBWJ3cd38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 33/49] tracing: Fix memory leaks in trace_events_hist.c
Date:   Fri,  8 May 2020 14:35:50 +0200
Message-Id: <20200508123047.600641190@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5f6834a2bf411..fcab11cc6833b 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3320,6 +3320,9 @@ static void __destroy_hist_field(struct hist_field *hist_field)
 	kfree(hist_field->name);
 	kfree(hist_field->type);
 
+	kfree(hist_field->system);
+	kfree(hist_field->event_name);
+
 	kfree(hist_field);
 }
 
@@ -4382,6 +4385,7 @@ static struct hist_field *create_var(struct hist_trigger_data *hist_data,
 		goto out;
 	}
 
+	var->ref = 1;
 	var->flags = HIST_FIELD_FL_VAR;
 	var->var.idx = idx;
 	var->var.hist_data = var->hist_data = hist_data;
@@ -5011,6 +5015,9 @@ static void destroy_field_vars(struct hist_trigger_data *hist_data)
 
 	for (i = 0; i < hist_data->n_field_vars; i++)
 		destroy_field_var(hist_data->field_vars[i]);
+
+	for (i = 0; i < hist_data->n_save_vars; i++)
+		destroy_field_var(hist_data->save_vars[i]);
 }
 
 static void save_field_var(struct hist_trigger_data *hist_data,
-- 
2.20.1



