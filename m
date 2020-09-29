Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A951A27C9D1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgI2MOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730107AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC6A23B23;
        Tue, 29 Sep 2020 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379228;
        bh=7OB6RWjA1q5chzgCBY94D09Hb0OdN7JRaoGvy11b7iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IV9/MImZmtAVW74dqAikx0SgF3F8k9z3+jXSLmMDYF+0qxZDJrSsfo3+1Ypi+LKzL
         2K35V2NgdVyz7GZc2DJY+u96B6mJEUsAejKowTX26ytCx1L8Nnb38N9w5dCzvruBx/
         Yohh56biYRfugmv2NLVEUO4J0ej25Tu3DFYWodow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <error27@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/388] kernel/sys.c: avoid copying possible padding bytes in copy_to_user
Date:   Tue, 29 Sep 2020 12:56:41 +0200
Message-Id: <20200929110013.885898127@linuxfoundation.org>
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
index a611d1d58c7d0..3459a5ce0da01 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1279,11 +1279,13 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 
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



