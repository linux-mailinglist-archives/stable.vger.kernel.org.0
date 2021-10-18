Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04116431D80
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhJRNwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233947AbhJRNuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A107D61875;
        Mon, 18 Oct 2021 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564267;
        bh=9jRwUoPbWPn0/D5vnNzpLm9PGuycKAtL5UHDwHXvofs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqWHyaw2naz2zRIZZShwAsseSB7rlesVkeTIZL9nFJGWfbuMOZOESkoqDbD8+uYzv
         uRqNjszu7ECXEoI1gH5GYUwkjVhQJqfDesNipgxYuQ0rCxSLJCrDJZZNbU8rF3bqe9
         hc86Ai2jJ2dsyh1IZ2cLpcLdsHCeZ768Uklm5K3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.14 024/151] csky: Fixup regs.sr broken in ptrace
Date:   Mon, 18 Oct 2021 15:23:23 +0200
Message-Id: <20211018132341.466668426@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit af89ebaa64de726ca0a39bbb0bf0c81a1f43ad50 upstream.

gpr_get() return the entire pt_regs (include sr) to userspace, if we
don't restore the C bit in gpr_set, it may break the ALU result in
that context. So the C flag bit is part of gpr context, that's why
riscv totally remove the C bit in the ISA. That makes sr reg clear
from userspace to supervisor privilege.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/csky/kernel/ptrace.c
+++ b/arch/csky/kernel/ptrace.c
@@ -99,7 +99,8 @@ static int gpr_set(struct task_struct *t
 	if (ret)
 		return ret;
 
-	regs.sr = task_pt_regs(target)->sr;
+	/* BIT(0) of regs.sr is Condition Code/Carry bit */
+	regs.sr = (regs.sr & BIT(0)) | (task_pt_regs(target)->sr & ~BIT(0));
 #ifdef CONFIG_CPU_HAS_HILO
 	regs.dcsr = task_pt_regs(target)->dcsr;
 #endif


