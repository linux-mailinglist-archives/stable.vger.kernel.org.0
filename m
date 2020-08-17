Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0D2475F8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388959AbgHQTbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730297AbgHQPb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2236C23120;
        Mon, 17 Aug 2020 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678318;
        bh=A9I3Y0ifFr5e1wqS1dyd2VKj/8QcHjUtO1jMJS1N00U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPn8JXIV6Y/EGoVPm9JVkJ/0Mp+B/7wXBxXW/Y2IfuIkoYHzxYbDrN+becZJaWNrm
         8TAcaftBnV3PJyCg/PP0XffNqgdPc6gQ+gyJNmm84rfTUE3tD8wbWd1ITzHWol1ZCr
         g7fRj8fjzG94h0sKD6Z3Hv5Xdqurb0qt+xEbgBu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milton Miller <miltonm@us.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 293/464] powerpc/watchpoint: Fix 512 byte boundary limit
Date:   Mon, 17 Aug 2020 17:14:06 +0200
Message-Id: <20200817143847.790438471@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 3190ecbfeeb2ab17778887ce3fa964615d6460fd ]

Milton Miller reported that we are aligning start and end address to
wrong size SZ_512M. It should be SZ_512. Fix that.

While doing this change I also found a case where ALIGN() comparison
fails. Within a given aligned range, ALIGN() of two addresses does not
match when start address is pointing to the first byte and end address
is pointing to any other byte except the first one. But that's not true
for ALIGN_DOWN(). ALIGN_DOWN() of any two addresses within that range
will always point to the first byte. So use ALIGN_DOWN() instead of
ALIGN().

Fixes: e68ef121c1f4 ("powerpc/watchpoint: Use builtin ALIGN*() macros")
Reported-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Tested-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200723090813.303838-2-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 0000daf0e1dae..031e6defc08e6 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -419,7 +419,7 @@ static int hw_breakpoint_validate_len(struct arch_hw_breakpoint *hw)
 	if (dawr_enabled()) {
 		max_len = DAWR_MAX_LEN;
 		/* DAWR region can't cross 512 bytes boundary */
-		if (ALIGN(start_addr, SZ_512M) != ALIGN(end_addr - 1, SZ_512M))
+		if (ALIGN_DOWN(start_addr, SZ_512) != ALIGN_DOWN(end_addr - 1, SZ_512))
 			return -EINVAL;
 	} else if (IS_ENABLED(CONFIG_PPC_8xx)) {
 		/* 8xx can setup a range without limitation */
-- 
2.25.1



