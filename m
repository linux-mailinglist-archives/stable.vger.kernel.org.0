Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110E0622AC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfGHP1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389165AbfGHP1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA03216C4;
        Mon,  8 Jul 2019 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599672;
        bh=mWMQHXqKZVR3al1nTYvxdRttsfifL0w1ICxxsQaXT3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4DRLGBK5yOVWvWmbwIcmQmywHL8IcKRWDSIl9eI6Lnz4XMK8KtqWmPjQ6xNlcqxp
         9HRYj53UJ+CYvxW2mgsDuy6QOLrrJiBzcshh98HbDW1303Lu6CuMpRcuHsjm4gybMQ
         84qTQTbhANvkAhs5QWwRBNBbyGgzmcIfi3UvyWzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/90] tracing: avoid build warning with HAVE_NOP_MCOUNT
Date:   Mon,  8 Jul 2019 17:13:04 +0200
Message-Id: <20190708150524.469699228@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cbdaeaf050b730ea02e9ab4ff844ce54d85dbe1d ]

Selecting HAVE_NOP_MCOUNT enables -mnop-mcount (if gcc supports it)
and sets CC_USING_NOP_MCOUNT. Reuse __is_defined (which is suitable for
testing CC_USING_* defines) to avoid conditional compilation and fix
the following gcc 9 warning on s390:

kernel/trace/ftrace.c:2514:1: warning: ‘ftrace_code_disable’ defined
but not used [-Wunused-function]

Link: http://lkml.kernel.org/r/patch.git-1a82d13f33ac.your-ad-here.call-01559732716-ext-6629@work.hours

Fixes: 2f4df0017baed ("tracing: Add -mcount-nop option support")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1688782f3dfb..90348b343460 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2952,14 +2952,13 @@ static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 			p = &pg->records[i];
 			p->flags = rec_flags;
 
-#ifndef CC_USING_NOP_MCOUNT
 			/*
 			 * Do the initial record conversion from mcount jump
 			 * to the NOP instructions.
 			 */
-			if (!ftrace_code_disable(mod, p))
+			if (!__is_defined(CC_USING_NOP_MCOUNT) &&
+			    !ftrace_code_disable(mod, p))
 				break;
-#endif
 
 			update_cnt++;
 		}
-- 
2.20.1



