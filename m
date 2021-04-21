Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF14366BB7
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbhDUNFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239853AbhDUNFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:05:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B538861455;
        Wed, 21 Apr 2021 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010286;
        bh=fHIhHWhbZ0ZhEMCmgbmyntppO5e7+bgAG3Mo5QZudmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9ZAJj9Ok1AnD6oyTDrXniGsEFAsdE0OKXejWL5p469GqRQ/+2mdGjv4/QQlTord3
         XaRwbeiLAQ6pIE4R+CczsYXoIT88xRs+nKtCg7Mg87oTK0TRL3uOoeknwUq/K428d+
         fgLDpsKp3ty6zKNRwLySF6KMzRgcgjDKew/qvD/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 081/190] Revert "tracing: Fix a memory leak by early error exit in trace_pid_write()"
Date:   Wed, 21 Apr 2021 14:59:16 +0200
Message-Id: <20210421130105.1226686-82-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 91862cc7867bba4ee5c8fcf0ca2f1d30427b6129.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: http
Cc: stable@vger.kernel.org
Cc: Wenwen Wang <wang6495@umn.edu>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c777627212f..faed4f44d224 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -691,10 +691,8 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	 * not modified.
 	 */
 	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
-	if (!pid_list) {
-		trace_parser_put(&parser);
+	if (!pid_list)
 		return -ENOMEM;
-	}
 
 	pid_list->pid_max = READ_ONCE(pid_max);
 
@@ -704,7 +702,6 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 
 	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
 	if (!pid_list->pids) {
-		trace_parser_put(&parser);
 		kfree(pid_list);
 		return -ENOMEM;
 	}
-- 
2.31.1

