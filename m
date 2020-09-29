Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7227C9A5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgI2MMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9404123B98;
        Tue, 29 Sep 2020 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379294;
        bh=Y87WWjGl1GuRKGIlBHPhg//1M4aHTBf8DvjsqAWO2Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5lhzfFt7W6GmIHMpTng+U6OPm6AY/zaponD3htX55MuL5te9aClZpf2fv6mfKG0H
         ZPpIe5SDQmPixVal5Iv4FwHOd8PD5PBm4OhK3ayTEo1z1vpauBmoyI7AwlVH9sYXMz
         7+8GUhV8tysy5BL8Yw4yh6sf9NGNn68bGZZO4838=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/388] tracing: Set kernel_stacks caller size properly
Date:   Tue, 29 Sep 2020 12:57:10 +0200
Message-Id: <20200929110015.272551999@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index fc8e97328e540..78c146efb8623 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -174,7 +174,7 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	F_STRUCT(
 		__field(	int,		size	)
-		__dynamic_array(unsigned long,	caller	)
+		__array(	unsigned long,	caller,	FTRACE_STACK_ENTRIES	)
 	),
 
 	F_printk("\t=> %ps\n\t=> %ps\n\t=> %ps\n"
-- 
2.25.1



