Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2690629B94F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764874AbgJ0PrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801272AbgJ0PjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8742C2225E;
        Tue, 27 Oct 2020 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813164;
        bh=Fd7ViidNz2XnheOKTRTAEYjBKTX1LdS1OOPdkcDTOLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgv7Qhxgn+6JrhP2HhY683EfLZu9GeiKtDyxqiWrp9lIxBHYDE1wqqkMXJ9gXT2Ls
         igMQma2tOyBJZWJshRTcHpkOAGH7Ndfro7ThP4kTK7u6xlLA2d84gG91Odnm38kTl1
         8tfO8RJr6vhZarHlkuvEVBvJiGIWLVACMjTSgaQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 441/757] powerpc/watchpoint: Fix handling of vector instructions
Date:   Tue, 27 Oct 2020 14:51:31 +0100
Message-Id: <20201027135511.224104960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 4441eb02333a9b46a0d919aa7a6d3b137b5f2562 ]

Vector load/store instructions are special because they are always
aligned. Thus unaligned EA needs to be aligned down before comparing
it with watch ranges. Otherwise we might consider valid event as
invalid.

Fixes: 74c6881019b7 ("powerpc/watchpoint: Prepare handler to handle more than one watchpoint")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902042945.129369-3-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 9f7df1c372330..f6b24838ca3c0 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -644,6 +644,8 @@ static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
 	if (*type == CACHEOP) {
 		*size = cache_op_size();
 		*ea &= ~(*size - 1);
+	} else if (*type == LOAD_VMX || *type == STORE_VMX) {
+		*ea &= ~(*size - 1);
 	}
 }
 
-- 
2.25.1



