Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A96E431BC3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhJRNfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233172AbhJRNdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2859861357;
        Mon, 18 Oct 2021 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563779;
        bh=ftJcYa5tYRmlDTN9v6teyzo1AQ+5+Sb5uPNE16kOzk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yobzgN81rb57r9e1qJaL7QMURrNvEMcb/Rr7kqj7RmtMvK1cLhVo8XT8h7HJnfjWH
         oNZrJQp7U42jZmiymQN3EPMh1sTWbm3wcrYtn0R+uD6ygbEmX5Np4wC7ysDNjXUuXs
         o2vvIJ1BfALZgcnheCaNLosCueuT5LXkdOEoLHN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 11/69] csky: Fixup regs.sr broken in ptrace
Date:   Mon, 18 Oct 2021 15:24:09 +0200
Message-Id: <20211018132329.825628897@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -96,7 +96,8 @@ static int gpr_set(struct task_struct *t
 	if (ret)
 		return ret;
 
-	regs.sr = task_pt_regs(target)->sr;
+	/* BIT(0) of regs.sr is Condition Code/Carry bit */
+	regs.sr = (regs.sr & BIT(0)) | (task_pt_regs(target)->sr & ~BIT(0));
 #ifdef CONFIG_CPU_HAS_HILO
 	regs.dcsr = task_pt_regs(target)->dcsr;
 #endif


