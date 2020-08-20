Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F4924B4F5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgHTKPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbgHTKO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:14:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD02B2067C;
        Thu, 20 Aug 2020 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918498;
        bh=HyOIHmSDJ15NT7/szmLfX12OAORiTgw/DRPWArtZKGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1610iFOTEpHACmHOZjcqvKSDews/Jaa4OnwYT00P2k7Vq6VmqKDaQo1foJvJskof
         YhBd4w1GB154EmOgez4p1mYmDDNnnNXGv6o0XrKACIpbrkzCvs3A4Eg26QPHmZHTyG
         duGejT4FQsuccfm5pd5w0NihK+yswXBkcv3bTQOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 185/228] ftrace: Setup correct FTRACE_FL_REGS flags for module
Date:   Thu, 20 Aug 2020 11:22:40 +0200
Message-Id: <20200820091616.819992188@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

commit 8a224ffb3f52b0027f6b7279854c71a31c48fc97 upstream.

When module loaded and enabled, we will use __ftrace_replace_code
for module if any ftrace_ops referenced it found. But we will get
wrong ftrace_addr for module rec in ftrace_get_addr_new, because
rec->flags has not been setup correctly. It can cause the callback
function of a ftrace_ops has FTRACE_OPS_FL_SAVE_REGS to be called
with pt_regs set to NULL.
So setup correct FTRACE_FL_REGS flags for rec when we call
referenced_filters to find ftrace_ops references it.

Link: https://lkml.kernel.org/r/20200728180554.65203-1-zhouchengming@bytedance.com

Cc: stable@vger.kernel.org
Fixes: 8c4f3c3fa9681 ("ftrace: Check module functions being traced on reload")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5721,8 +5721,11 @@ static int referenced_filters(struct dyn
 	int cnt = 0;
 
 	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
-		if (ops_references_rec(ops, rec))
-		    cnt++;
+		if (ops_references_rec(ops, rec)) {
+			cnt++;
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+				rec->flags |= FTRACE_FL_REGS;
+		}
 	}
 
 	return cnt;
@@ -5871,8 +5874,8 @@ void ftrace_module_enable(struct module
 		if (ftrace_start_up)
 			cnt += referenced_filters(rec);
 
-		/* This clears FTRACE_FL_DISABLED */
-		rec->flags = cnt;
+		rec->flags &= ~FTRACE_FL_DISABLED;
+		rec->flags += cnt;
 
 		if (ftrace_start_up && cnt) {
 			int failed = __ftrace_replace_code(rec, 1);


