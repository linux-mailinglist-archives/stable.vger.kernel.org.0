Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC7C3A608B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhFNKf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhFNKds (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4233F60D07;
        Mon, 14 Jun 2021 10:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666701;
        bh=K2QGJxLnGYUHtMfavV/sEVxakvSo/ZfT7/pyzJ5yUis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUi6JFG+0N5Zv3fozTauwwRLdWUn28V4qopC432X/W6VWpK2uICWeKL0BQGvSh5gA
         3YCRvHssmoqmg1lwErKY5Wt5dhOF8tRXo5JldoLRrrevToULiVa5SbQtf4qs/nCaGy
         2p/ZmisnwSStLZkcMfEue0O+LmrjHW14luc9gDFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 41/42] ftrace: Do not blindly read the ip address in ftrace_bug()
Date:   Mon, 14 Jun 2021 12:27:32 +0200
Message-Id: <20210614102644.016353739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 6c14133d2d3f768e0a35128faac8aa6ed4815051 upstream.

It was reported that a bug on arm64 caused a bad ip address to be used for
updating into a nop in ftrace_init(), but the error path (rightfully)
returned -EINVAL and not -EFAULT, as the bug caused more than one error to
occur. But because -EINVAL was returned, the ftrace_bug() tried to report
what was at the location of the ip address, and read it directly. This
caused the machine to panic, as the ip was not pointing to a valid memory
address.

Instead, read the ip address with copy_from_kernel_nofault() to safely
access the memory, and if it faults, report that the address faulted,
otherwise report what was in that location.

Link: https://lore.kernel.org/lkml/20210607032329.28671-1-mark-pk.tsai@mediatek.com/

Cc: stable@vger.kernel.org
Fixes: 05736a427f7e1 ("ftrace: warn on failure to disable mcount callers")
Reported-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1961,12 +1961,18 @@ static int ftrace_hash_ipmodify_update(s
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
 {
+	char ins[MCOUNT_INSN_SIZE];
 	int i;
 
+	if (probe_kernel_read(ins, p, MCOUNT_INSN_SIZE)) {
+		printk(KERN_CONT "%s[FAULT] %px\n", fmt, p);
+		return;
+	}
+
 	printk(KERN_CONT "%s", fmt);
 
 	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+		printk(KERN_CONT "%s%02x", i ? ":" : "", ins[i]);
 }
 
 enum ftrace_bug_type ftrace_bug_type;


