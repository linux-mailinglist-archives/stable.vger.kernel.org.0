Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E67FEDA5
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfKPPpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfKPPpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:45:43 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E54382081E;
        Sat, 16 Nov 2019 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919143;
        bh=mVdXT8KgpU+9tvB2z5w+5sXBmDF6P0AEXBz5zUQsBtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOd6vZzaot7kV0+pYAe51/ugYUGLWcWCS8xHnDjDbZ3zIYKZySIAcTRLxxoLF4pTA
         lDWc4R/kiRNhRgvuMrgx2lrmtkC9IHolhb4Xif6THmSqSQgydpdInVfBOXLEqqn+LE
         hJI1GAwWZhHffIj2xfGxggZ74kXOSS2cVlW/2mBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 162/237] kernel/panic.c: do not append newline to the stack protector panic string
Date:   Sat, 16 Nov 2019 10:39:57 -0500
Message-Id: <20191116154113.7417-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 95c4fb78fb23081472465ca20d5d31c4b780ed82 ]

... because panic() itself already does this. Otherwise you have
line-broken trailer:

  [    1.836965] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: pgd_alloc+0x29e/0x2a0
  [    1.836965]  ]---

Link: http://lkml.kernel.org/r/20181008202901.7894-1-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 72e001e3753e3..8138a676fb7d1 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -636,7 +636,7 @@ device_initcall(register_warn_debugfs);
  */
 __visible void __stack_chk_fail(void)
 {
-	panic("stack-protector: Kernel stack is corrupted in: %pB\n",
+	panic("stack-protector: Kernel stack is corrupted in: %pB",
 		__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__stack_chk_fail);
-- 
2.20.1

