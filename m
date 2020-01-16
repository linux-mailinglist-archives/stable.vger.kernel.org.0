Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF58713FE02
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391533AbgAPXbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388848AbgAPXbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E645D20684;
        Thu, 16 Jan 2020 23:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217507;
        bh=0Sj61wdwXAjuc7aRI9NN2NGUCyBAc+0Yv3dWyujHqAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmuncUzdfk+EMBB5i5jweIaJXZjqpa2c8vTqx4Qhn54iLeApvoG0hXd+KiJlEIG6X
         CmLZtOP7n+w1S5tgbYKSNxykZQAoH/YK1Jry8ynH/TW+L5sAZ6yGXyPaNGg5weJnx/
         WVpEQlapUOkESSpNYkfvVVidXJsOrg86/mWJ1vkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andi Kleen <ak@linux.intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 4.14 05/71] fs/select: avoid clang stack usage warning
Date:   Fri, 17 Jan 2020 00:18:03 +0100
Message-Id: <20200116231710.184490597@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit ad312f95d41c9de19313c51e388c4984451c010f upstream.

The select() implementation is carefully tuned to put a sensible amount
of data on the stack for holding a copy of the user space fd_set, but
not too large to risk overflowing the kernel stack.

When building a 32-bit kernel with clang, we need a little more space
than with gcc, which often triggers a warning:

  fs/select.c:619:5: error: stack frame size of 1048 bytes in function 'core_sys_select' [-Werror,-Wframe-larger-than=]
  int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,

I experimentally found that for 32-bit ARM, reducing the maximum stack
usage by 64 bytes keeps us reliably under the warning limit again.

Link: http://lkml.kernel.org/r/20190307090146.1874906-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/poll.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -15,7 +15,11 @@
 extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
+#ifdef __clang__
+#define MAX_STACK_ALLOC 768
+#else
 #define MAX_STACK_ALLOC 832
+#endif
 #define FRONTEND_STACK_ALLOC	256
 #define SELECT_STACK_ALLOC	FRONTEND_STACK_ALLOC
 #define POLL_STACK_ALLOC	FRONTEND_STACK_ALLOC


