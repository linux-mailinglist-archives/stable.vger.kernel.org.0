Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD3DB1F42
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbfIMNRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390065AbfIMNRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:30 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9A9206A5;
        Fri, 13 Sep 2019 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380649;
        bh=6ILFhvEXDEnSURpR9RZAmjptUv5yCKrkEql3WkcJjys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ms2rfjVD3X7acwphQLEx22Mw0bxDCFKXWuqoByQuLPqgtPgvcOQuZMIxT+20cbxX2
         6IIOPdwZjSuXjp9JdC80XiSlPd4Vs7QZpn6i0RA0nokbrWnfKVEpU/lX9HfIGvd2Y2
         jOWNyMyY3X0VGWgfDkdeuQur0PrZNcW4WS3OPp7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/190] ARC: mm: fix uninitialised signal code in do_page_fault
Date:   Fri, 13 Sep 2019 14:06:28 +0100
Message-Id: <20190913130610.582710456@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 121e38e5acdc8e1e4cdb750fcdcc72f94e420968 ]

Commit 15773ae938d8 ("signal/arc: Use force_sig_fault where
appropriate") introduced undefined behaviour by leaving si_code
unitiailized and leaking random kernel values to user space.

Fixes: 15773ae938d8 ("signal/arc: Use force_sig_fault where appropriate")
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index a0366f9dca051..535cf18e8bf2c 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -66,7 +66,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	struct vm_area_struct *vma = NULL;
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	int si_code;
+	int si_code = 0;
 	int ret;
 	vm_fault_t fault;
 	int write = regs->ecr_cause & ECR_C_PROTV_STORE;  /* ST/EX */
-- 
2.20.1



