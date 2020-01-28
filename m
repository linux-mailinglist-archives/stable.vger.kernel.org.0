Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D853814B69E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgA1OEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgA1OEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030EF24688;
        Tue, 28 Jan 2020 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220262;
        bh=QuURjKC5p50u5pwWW0BohDmU93jrwtJYbv5Osn5F+hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwGKGppLiRhu06bF6U5DbjMSZpoizbjbc69NAYQ0mU7o8udBq2zN58Q4cbrxJJW2+
         UkN9NJcUAAdLsGuoGpYPcgxVWqMUYD/sY2Rpu6t+KzRx+odchLIsJYP9qviX2Sv0+M
         WopQ5CvU9vcJHjxyIhZ2gTpg5VPcBxVtZo0JQVWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Ichikawa <masami256@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 044/104] tracing: Do not set trace clock if tracefs lockdown is in effect
Date:   Tue, 28 Jan 2020 15:00:05 +0100
Message-Id: <20200128135823.801981789@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Ichikawa <masami256@gmail.com>

commit bf24daac8f2bd5b8affaec03c2be1d20bcdd6837 upstream.

When trace_clock option is not set and unstable clcok detected,
tracing_set_default_clock() sets trace_clock(ThinkPad A285 is one of
case). In that case, if lockdown is in effect, null pointer
dereference error happens in ring_buffer_set_clock().

Link: http://lkml.kernel.org/r/20200116131236.3866925-1-masami256@gmail.com

Cc: stable@vger.kernel.org
Fixes: 17911ff38aa58 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1788488
Signed-off-by: Masami Ichikawa <masami256@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9270,6 +9270,11 @@ __init static int tracing_set_default_cl
 {
 	/* sched_clock_stable() is determined in late_initcall */
 	if (!trace_boot_clock && !sched_clock_stable()) {
+		if (security_locked_down(LOCKDOWN_TRACEFS)) {
+			pr_warn("Can not set tracing clock due to lockdown\n");
+			return -EPERM;
+		}
+
 		printk(KERN_WARNING
 		       "Unstable clock detected, switching default tracing clock to \"global\"\n"
 		       "If you want to keep using the local clock, then add:\n"


