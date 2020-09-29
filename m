Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86B227C485
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgI2LOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgI2LOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC0021D41;
        Tue, 29 Sep 2020 11:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378071;
        bh=luAx4X+I/dJfTAXORFZBzGx6TP/aQbWoHfjFpBNUjR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8H6T32SbQhX6EWxwe6S2qNo8z5yK5wRtfWa+PedaFMVXcrrWVYL8cVy2/cLQXdDf
         QapX9YH4zbF5wwcIK6Uot74UEKZfivrrxxArC/Jqw3YED8Yfj7IyrhG+yeC86s1yX8
         lev03jlJ7Klsl6jJPwOaQpx5K4wlB7ZBSPZboVI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/166] tracing: Set kernel_stacks caller size properly
Date:   Tue, 29 Sep 2020 12:59:22 +0200
Message-Id: <20200929105937.701380697@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

[ Upstream commit cbc3b92ce037f5e7536f6db157d185cd8b8f615c ]

I noticed when trying to use the trace-cmd python interface that reading the raw
buffer wasn't working for kernel_stack events.  This is because it uses a
stubbed version of __dynamic_array that doesn't do the __data_loc trick and
encode the length of the array into the field.  Instead it just shows up as a
size of 0.  So change this to __array and set the len to FTRACE_STACK_ENTRIES
since this is what we actually do in practice and matches how user_stack_trace
works.

Link: http://lkml.kernel.org/r/1411589652-1318-1-git-send-email-jbacik@fb.com

Signed-off-by: Josef Bacik <jbacik@fb.com>
[ Pulled from the archeological digging of my INBOX ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_entries.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index e3a658bac10fe..ff91acff72946 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -179,7 +179,7 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	F_STRUCT(
 		__field(	int,		size	)
-		__dynamic_array(unsigned long,	caller	)
+		__array(	unsigned long,	caller,	FTRACE_STACK_ENTRIES	)
 	),
 
 	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
-- 
2.25.1



