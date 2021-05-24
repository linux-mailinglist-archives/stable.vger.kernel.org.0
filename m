Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166EC38EBBA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhEXPGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhEXPDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4414D61580;
        Mon, 24 May 2021 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867830;
        bh=eThF42QgHM2ceyuUbfHXSeQsf1W1pocY7rix57lF/sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yx2pNExa0JtRgzJZdMjfFVPUIwM9DEI7tRxOoFJLvzJvZ5q5LjurZ1i3ORpsoDVKF
         9eKivga8BXybgTmJv0VY9aEyUz3j4QTySdbJJ9s3PQvkCBO+Jf7SNPH5S+AqdQPUGH
         Ks4jAc+mDe8qDfOJKkkVpzFd1FFMH0B3l4nik0d1JwddMl+JpN8k8vWcRNzTJuT0RN
         74GzCjIWD2tsAPAUSpKzL916d5TWaCgmp0SsVxp1X3bOXtQD7CjCRfYt+IK9y4Isa1
         CiWLzn4Ia3Kmnqa1AqEibxeb7NY7uQNvb76un5zhm3HoRRW6Qvs/Lxq9qDZhvYjuIj
         Z71CtQpKoDNWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>, openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 4.19 18/25] openrisc: Define memory barrier mb
Date:   Mon, 24 May 2021 10:50:01 -0400
Message-Id: <20210524145008.2499049-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
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

