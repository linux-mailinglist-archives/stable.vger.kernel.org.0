Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B808C26EDB6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgIRCXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbgIRCQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2104A2395B;
        Fri, 18 Sep 2020 02:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395418;
        bh=7Xh9F1ci2528vKTY1xThQGNGytWsAB3Od7yBhA/c6bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s53jiCzF1RDL5BI/nZn0pvrl66t+Rbc8WxaM65xAQ5h4wJG0zlEtmw7C95n17qUlU
         Qtibizsgnc5HvBlAN/tVbdZvuvgbGnsQ4HmePRIhTLoWq8rwqNGLl/Xrdt3GG/Yk6K
         W7reVTeZbXYNJs7empwSYIXazK2dGZU3b6DQ3zcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>, Dan Carpenter <error27@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 12/64] kernel/sys.c: avoid copying possible padding bytes in copy_to_user
Date:   Thu, 17 Sep 2020 22:15:51 -0400
Message-Id: <20200918021643.2067895-12-sashal@kernel.org>
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

From: Joe Perches <joe@perches.com>

[ Upstream commit 5e1aada08cd19ea652b2d32a250501d09b02ff2e ]

Initialization is not guaranteed to zero padding bytes so use an
explicit memset instead to avoid leaking any kernel content in any
possible padding bytes.

Link: http://lkml.kernel.org/r/dfa331c00881d61c8ee51577a082d8bebd61805c.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 1855f1bf113e4..e98664039cb23 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1183,11 +1183,13 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 
 SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 {
-	struct oldold_utsname tmp = {};
+	struct oldold_utsname tmp;
 
 	if (!name)
 		return -EFAULT;
 
+	memset(&tmp, 0, sizeof(tmp));
+
 	down_read(&uts_sem);
 	memcpy(&tmp.sysname, &utsname()->sysname, __OLD_UTS_LEN);
 	memcpy(&tmp.nodename, &utsname()->nodename, __OLD_UTS_LEN);
-- 
2.25.1

