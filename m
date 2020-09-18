Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF9526EDAC
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgIRCWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729490AbgIRCRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87F9023772;
        Fri, 18 Sep 2020 02:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395423;
        bh=70QjCaOHpMZNXQETwGddEY2WVyd87achreBJ2LYAhVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=el8gIkB7196h+Tqi8sel/eRavA5hc9BbcP+ztS4xAJUNaZjXKBUtkJ/Brha2BXLND
         v+OywVf2msGd0+5N9lreJry7AYl+fEh8OGcgJGrB/3JlOrbBz7CQLJtLxqqOcB4uqY
         58XuRMEZpthWDs2cuwHJenm+4Znr33+RezhU4ziw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 17/64] tracing: Set kernel_stack's caller size properly
Date:   Thu, 17 Sep 2020 22:15:56 -0400
Message-Id: <20200918021643.2067895-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ee7b94a4810af..246db27dbdc99 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -178,7 +178,7 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 
 	F_STRUCT(
 		__field(	int,		size	)
-		__dynamic_array(unsigned long,	caller	)
+		__array(	unsigned long,	caller,	FTRACE_STACK_ENTRIES	)
 	),
 
 	F_printk("\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n\t=> (" IP_FMT ")\n"
-- 
2.25.1

