Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F57427CD02
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbgI2Mkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbgI2LOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A162921D7F;
        Tue, 29 Sep 2020 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378046;
        bh=S/ecVBd/Rs0ESn0Ri9vM4zwhlvAwvHpATaRFrH6Ba/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPN/8pp/brf5EPabrXk5uE07i/tD4WQENL2EaKcX2U4c2bQnYzoM/0/Hv4t53D8FZ
         IlfueZzNkgHvokjmR7phpS388SXDkLeugTJclvMrKpUglOYoH3dLUBiUSFefDYh4EI
         C1OPky4qzgrQpS3yLdtAnn/w32CPXn7sby1lDyBk=
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
Subject: [PATCH 4.14 042/166] kernel/sys.c: avoid copying possible padding bytes in copy_to_user
Date:   Tue, 29 Sep 2020 12:59:14 +0200
Message-Id: <20200929105937.301008174@linuxfoundation.org>
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
index ab96b98823473..2e4f017f7c5aa 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1217,11 +1217,13 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 
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



