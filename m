Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE229B4D3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793549AbgJ0PG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790305AbgJ0PEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A9F20747;
        Tue, 27 Oct 2020 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811063;
        bh=RFMwSIua67ij+5d8vhBow1V7AfxFAiUOljRmCneloQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPEvzyKjoa8JWnpTZ3I+EuNcDji6kPW+50zT6aAtj32vwnrHxMUwDlNI8BodEPXfc
         YTHboTC5P3FfXQdbXzEArLT9hFnd8kn5ZSFMmZfm01rbJfyHzbZ0ilW0UV/8Uw4P9w
         8mUnrkcqCDbwyHtF9/tmSy9eBSc2Ia7KKuOwKzbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 361/633] powerpc/watchpoint: Fix handling of vector instructions
Date:   Tue, 27 Oct 2020 14:51:44 +0100
Message-Id: <20201027135539.627901619@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index f39e86d751144..2190be70c7fd9 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -643,6 +643,8 @@ static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
 	if (*type == CACHEOP) {
 		*size = cache_op_size();
 		*ea &= ~(*size - 1);
+	} else if (*type == LOAD_VMX || *type == STORE_VMX) {
+		*ea &= ~(*size - 1);
 	}
 }
 
-- 
2.25.1



