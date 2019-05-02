Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA25F11F6A
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfEBPYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfEBPYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCC620449;
        Thu,  2 May 2019 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810670;
        bh=FOmfNYzrEcYHiizwPB2Abb9CIdjXvYYpGgBTBPqlJyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9gSnRSwYwfjvHH5GjRXRrwGPl+CQnixZ35eD5ZNBhGwxQNMzIXD0T6XDYJjkoY1l
         FHVXTdIk8wb2zSbl1dnzcDq5dKIJGe/d10JwncM1u/zS8Y8TTwYcwq7IifqMiJvc7s
         oaRpzj4roQvQP8Z8I19b4AbBrVmRYU0TMbhrKnsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 09/49] s390: limit brk randomization to 32MB
Date:   Thu,  2 May 2019 17:20:46 +0200
Message-Id: <20190502143325.270778454@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cd479eccd2e057116d504852814402a1e68ead80 ]

For a 64-bit process the randomization of the program break is quite
large with 1GB. That is as big as the randomization of the anonymous
mapping base, for a test case started with '/lib/ld64.so.1 <exec>'
it can happen that the heap is placed after the stack. To avoid
this limit the program break randomization to 32MB for 64-bit and
keep 8MB for 31-bit.

Reported-by: Stefan Liebler <stli@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/s390/include/asm/elf.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 1a61b1b997f2..3055c030f765 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -252,11 +252,14 @@ do {								\
 
 /*
  * Cache aliasing on the latest machines calls for a mapping granularity
- * of 512KB. For 64-bit processes use a 512KB alignment and a randomization
- * of up to 1GB. For 31-bit processes the virtual address space is limited,
- * use no alignment and limit the randomization to 8MB.
+ * of 512KB for the anonymous mapping base. For 64-bit processes use a
+ * 512KB alignment and a randomization of up to 1GB. For 31-bit processes
+ * the virtual address space is limited, use no alignment and limit the
+ * randomization to 8MB.
+ * For the additional randomization of the program break use 32MB for
+ * 64-bit and 8MB for 31-bit.
  */
-#define BRK_RND_MASK	(is_compat_task() ? 0x7ffUL : 0x3ffffUL)
+#define BRK_RND_MASK	(is_compat_task() ? 0x7ffUL : 0x1fffUL)
 #define MMAP_RND_MASK	(is_compat_task() ? 0x7ffUL : 0x3ff80UL)
 #define MMAP_ALIGN_MASK	(is_compat_task() ? 0 : 0x7fUL)
 #define STACK_RND_MASK	MMAP_RND_MASK
-- 
2.19.1



