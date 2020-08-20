Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1324BEAA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgHTN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgHTJc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765EE22BEA;
        Thu, 20 Aug 2020 09:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915973;
        bh=ACTaPf3WB8xQMkrMtFCoSoFHetoXM3EoWgiMsXUUXhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+PcxT1bBYHDPhmmKOFBtm9FEflpZ7e69OYeDOJvk9OX2GPwYWjQ349I6joOBQUTs
         hbG/n+Wm9htNJy4B6xX4q4L/HrGMOrpgZYjCHAtT1XIdoTjYjcvMUlNyyx6KQMO/ME
         t3p6FIwvYywhlhNeRHH9XTcUh9rn64YHa7QwDjFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 200/232] s390/test_unwind: fix possible memleak in test_unwind()
Date:   Thu, 20 Aug 2020 11:20:51 +0200
Message-Id: <20200820091622.495075224@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 75d3e7f4769d276a056efa1cc7f08de571fc9b4b ]

test_unwind() misses to call kfree(bt) in an error path.
Add the missed function call to fix it.

Fixes: 0610154650f1 ("s390/test_unwind: print verbose unwinding results")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/test_unwind.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
index 32b7a30b2485d..b0b12b46bc572 100644
--- a/arch/s390/lib/test_unwind.c
+++ b/arch/s390/lib/test_unwind.c
@@ -63,6 +63,7 @@ static noinline int test_unwind(struct task_struct *task, struct pt_regs *regs,
 			break;
 		if (state.reliable && !addr) {
 			pr_err("unwind state reliable but addr is 0\n");
+			kfree(bt);
 			return -EINVAL;
 		}
 		sprint_symbol(sym, addr);
-- 
2.25.1



