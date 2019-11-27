Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB910BCE9
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbfK0VCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731916AbfK0VCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D7721771;
        Wed, 27 Nov 2019 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888557;
        bh=mVdXT8KgpU+9tvB2z5w+5sXBmDF6P0AEXBz5zUQsBtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUT7eN8J4FZPR/CaIf2ZlX16SS+ki4DKC092wz18g8G9o/uvkUTQ1x6RMovWYCx1S
         NOlCFSjBg49bO3TACpHZM7cJVYuCnOXg6r4xOp5vlAr5CyxLYVxBWiocWyhdC7qIoj
         fowg20PkcXvv+TqiA2mh3LaagtragYV66Lz21KNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/306] kernel/panic.c: do not append newline to the stack protector panic string
Date:   Wed, 27 Nov 2019 21:30:29 +0100
Message-Id: <20191127203128.406585408@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



