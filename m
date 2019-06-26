Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3343B55FEE
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfFZDnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfFZDnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:31 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85231216FD;
        Wed, 26 Jun 2019 03:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520610;
        bh=50lWJvOZvTRDlHda/ii0W4rrPTwOONp9CJcoe2U06m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3ElG9vY3Ys+uUQjApjD5KzngqbLg4MQFnW2PMatLpMQmK0F9bTygiXsY8bLb5Poo
         qHboaKYARWZxRFMfv3oSBjrvf3tSRthuKKiHrPG2VzkiP/Pl0SdG24azMdqrD30yix
         lr2y/7NY0MgQaflGzf1ORHBgWcH/YHd6gNHRMBFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 49/51] tracing: avoid build warning with HAVE_NOP_MCOUNT
Date:   Tue, 25 Jun 2019 23:41:05 -0400
Message-Id: <20190626034117.23247-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

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
index b920358dd8f7..538f0b1c7ea2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2939,14 +2939,13 @@ static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
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

