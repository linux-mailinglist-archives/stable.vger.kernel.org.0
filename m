Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC7649A9A0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3420240AbiAYDZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:25:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55406 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353476AbiAXVDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4758A61330;
        Mon, 24 Jan 2022 21:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F37C340E8;
        Mon, 24 Jan 2022 21:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058186;
        bh=v6/FXpNGzXAE6TYf3fSLBuAkE9l9oQwNd47fnT/FRjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crUKKgIScQfakz6m85UahN/T+kKgZHdyhYnJ4bEjAEzBilkqHsmH1YjJzHDeB3F4p
         NscIcschExw1c0agGjbHctp5Lm8CzHIYBRIA3BAK6jbjFFBF2iOiCmzd9tCh9hMTz0
         tk4C3Z0+8aPp6ZtZO7pXl12T7S0fpaYrd+IhyO1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0208/1039] cgroup: Trace event cgroup id fields should be u64
Date:   Mon, 24 Jan 2022 19:33:17 +0100
Message-Id: <20220124184132.315640037@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Kucharski <william.kucharski@oracle.com>

[ Upstream commit e14da77113bb890d7bf9e5d17031bdd476a7ce5e ]

Various trace event fields that store cgroup IDs were declared as
ints, but cgroup_id(() returns a u64 and the structures and associated
TP_printk() calls were not updated to reflect this.

Fixes: 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID")
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/cgroup.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/cgroup.h b/include/trace/events/cgroup.h
index 7f42a3de59e6b..dd7d7c9efecdf 100644
--- a/include/trace/events/cgroup.h
+++ b/include/trace/events/cgroup.h
@@ -59,8 +59,8 @@ DECLARE_EVENT_CLASS(cgroup,
 
 	TP_STRUCT__entry(
 		__field(	int,		root			)
-		__field(	int,		id			)
 		__field(	int,		level			)
+		__field(	u64,		id			)
 		__string(	path,		path			)
 	),
 
@@ -71,7 +71,7 @@ DECLARE_EVENT_CLASS(cgroup,
 		__assign_str(path, path);
 	),
 
-	TP_printk("root=%d id=%d level=%d path=%s",
+	TP_printk("root=%d id=%llu level=%d path=%s",
 		  __entry->root, __entry->id, __entry->level, __get_str(path))
 );
 
@@ -126,8 +126,8 @@ DECLARE_EVENT_CLASS(cgroup_migrate,
 
 	TP_STRUCT__entry(
 		__field(	int,		dst_root		)
-		__field(	int,		dst_id			)
 		__field(	int,		dst_level		)
+		__field(	u64,		dst_id			)
 		__field(	int,		pid			)
 		__string(	dst_path,	path			)
 		__string(	comm,		task->comm		)
@@ -142,7 +142,7 @@ DECLARE_EVENT_CLASS(cgroup_migrate,
 		__assign_str(comm, task->comm);
 	),
 
-	TP_printk("dst_root=%d dst_id=%d dst_level=%d dst_path=%s pid=%d comm=%s",
+	TP_printk("dst_root=%d dst_id=%llu dst_level=%d dst_path=%s pid=%d comm=%s",
 		  __entry->dst_root, __entry->dst_id, __entry->dst_level,
 		  __get_str(dst_path), __entry->pid, __get_str(comm))
 );
@@ -171,8 +171,8 @@ DECLARE_EVENT_CLASS(cgroup_event,
 
 	TP_STRUCT__entry(
 		__field(	int,		root			)
-		__field(	int,		id			)
 		__field(	int,		level			)
+		__field(	u64,		id			)
 		__string(	path,		path			)
 		__field(	int,		val			)
 	),
@@ -185,7 +185,7 @@ DECLARE_EVENT_CLASS(cgroup_event,
 		__entry->val = val;
 	),
 
-	TP_printk("root=%d id=%d level=%d path=%s val=%d",
+	TP_printk("root=%d id=%llu level=%d path=%s val=%d",
 		  __entry->root, __entry->id, __entry->level, __get_str(path),
 		  __entry->val)
 );
-- 
2.34.1



