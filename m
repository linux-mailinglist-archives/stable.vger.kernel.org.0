Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DA63A6031
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhFNKcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232849AbhFNKbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5FE561245;
        Mon, 14 Jun 2021 10:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666591;
        bh=EgHBOKPa1VR7ueQvBTaHZ2pNhJCTpuwY/RABMEZcPn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHCPgHJo4OncgN/pG6bOeugHWz3O+/7KKgJy3G+nlR1QZ1Ykrc76/0TRRgxP6hdZE
         uE47Baa/esTIWgEoKaFBHHvNxYOft9RRBzq88zdSPNqYlS8odODgrbwAlzZGFXxiPm
         DQCMtiTTBGgKiX74mEgj0N3NtqsmMYoG7ICna2kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 34/34] ftrace: Do not blindly read the ip address in ftrace_bug()
Date:   Mon, 14 Jun 2021 12:27:25 +0200
Message-Id: <20210614102642.674418435@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
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
@@ -1943,12 +1943,18 @@ static int ftrace_hash_ipmodify_update(s
 
 static void print_ip_ins(const char *fmt, unsigned char *p)
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
 
 static struct ftrace_ops *


