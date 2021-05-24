Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4238E9BC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhEXOu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhEXOs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 880C0613DF;
        Mon, 24 May 2021 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867642;
        bh=eThF42QgHM2ceyuUbfHXSeQsf1W1pocY7rix57lF/sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmdJlSJ6MA7kxbZB3wbI+cVHfiKwHePXXq5fcd9uaqHHxTV3PYjIu1Le/1na+ifW5
         8luPMFPMqIaXnT7BvF6UKF2U141RtNSVQ9DC8EAVHl13cQUC11cwfNcBmozTVaKjAi
         ofMqPef6cbgLXaoeZ04L6toclCEs3uBrVC5k2dMpev5Nzbo8ebu3O89U/WCtmSOJ5J
         zZpIsfpz9EK1ihlxh3j8IuZtq31T+6uERk83yedzoZumsrYbFEsjOh9tsyY6j6PRr/
         KJtKPLzZ0NiVJHXpUEDAcuQ7GFd5lK+dMBC3cwVEppAj4tJOm73yQs7V7r4NPdW9Xl
         bY7ikBeosuhSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>, openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.12 47/63] openrisc: Define memory barrier mb
Date:   Mon, 24 May 2021 10:46:04 -0400
Message-Id: <20210524144620.2497249-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 8b549c18ae81dbc36fb11e4aa08b8378c599ca95 ]

This came up in the discussion of the requirements of qspinlock on an
architecture.  OpenRISC uses qspinlock, but it was noticed that the
memmory barrier was not defined.

Peter defined it in the mail thread writing:

    As near as I can tell this should do. The arch spec only lists
    this one instruction and the text makes it sound like a completion
    barrier.

This is correct so applying this patch.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[shorne@gmail.com:Turned the mail into a patch]
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/include/asm/barrier.h | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 arch/openrisc/include/asm/barrier.h

diff --git a/arch/openrisc/include/asm/barrier.h b/arch/openrisc/include/asm/barrier.h
new file mode 100644
index 000000000000..7538294721be
--- /dev/null
+++ b/arch/openrisc/include/asm/barrier.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+#define mb() asm volatile ("l.msync" ::: "memory")
+
+#include <asm-generic/barrier.h>
+
+#endif /* __ASM_BARRIER_H */
-- 
2.30.2

