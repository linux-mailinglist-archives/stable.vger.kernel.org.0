Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59919084
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEISph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfEISpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C617217F5;
        Thu,  9 May 2019 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427535;
        bh=vF+lWQtoC6+UM7ZibawzX9nioyvhBcNcaLQEhoJC92I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcULc3VM9BSqD0Kb7E/vYLGAOHHke+ATKw+8cBS3gfNsXo9HorXo2mn1PJYkqHJ9K
         Uhgi5GKA5htodJR4PMrM2TPnrSc9ZawMKmekn2nHQHzRhFRlXokrKXAh2ssyuuxg2M
         /iCe2GwgrhcMTy9ADj6DPukWwupBQOcosJSnesKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/42] xtensa: fix initialization of pt_regs::syscall in start_thread
Date:   Thu,  9 May 2019 20:42:08 +0200
Message-Id: <20190509181256.614576168@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2663147dc7465cb29040a05cc4286fdd839978b5 ]

New pt_regs should indicate that there's no syscall, not that there's
syscall #0. While at it wrap macro body in do/while and parenthesize
macro arguments.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/processor.h | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index a39cd81b741ad..3a0a8a53f2e72 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -195,15 +195,18 @@ struct thread_struct {
 
 /* Clearing a0 terminates the backtrace. */
 #define start_thread(regs, new_pc, new_sp) \
-	memset(regs, 0, sizeof(*regs)); \
-	regs->pc = new_pc; \
-	regs->ps = USER_PS_VALUE; \
-	regs->areg[1] = new_sp; \
-	regs->areg[0] = 0; \
-	regs->wmask = 1; \
-	regs->depc = 0; \
-	regs->windowbase = 0; \
-	regs->windowstart = 1;
+	do { \
+		memset((regs), 0, sizeof(*(regs))); \
+		(regs)->pc = (new_pc); \
+		(regs)->ps = USER_PS_VALUE; \
+		(regs)->areg[1] = (new_sp); \
+		(regs)->areg[0] = 0; \
+		(regs)->wmask = 1; \
+		(regs)->depc = 0; \
+		(regs)->windowbase = 0; \
+		(regs)->windowstart = 1; \
+		(regs)->syscall = NO_SYSCALL; \
+	} while (0)
 
 /* Forward declaration */
 struct task_struct;
-- 
2.20.1



