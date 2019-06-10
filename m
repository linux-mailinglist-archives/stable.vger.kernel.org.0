Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD03B696
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390335AbfFJN6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:58:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:33234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389373AbfFJN6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 09:58:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EFEDABD2;
        Mon, 10 Jun 2019 13:58:24 +0000 (UTC)
Date:   Mon, 10 Jun 2019 15:58:23 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Stable tree <stable@vger.kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH stable 4.4 v2] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190610135823.GI30967@dhcp22.suse.cz>
References: <20190604094953.26688-1-mhocko@kernel.org>
 <20190610074635.2319-1-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610074635.2319-1-mhocko@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just a heads up. Ajay Kaher has noticed that mlx4 driver is missing the
check in 4.14 [1] and 4.4 seems to have the same problem. I will wait
for more review before reposting v3. The incremental diff is:

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 67c4c73343d4..6968154a073e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1042,6 +1042,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx4_ib_vma_close().
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	for (i = 0; i < HW_BAR_COUNT; i++) {
 		vma = context->hw_bar_info[i].vma;
 		if (!vma)
@@ -1061,6 +1063,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		context->hw_bar_info[i].vma->vm_ops = NULL;
 	}
 
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
-- 
Michal Hocko
SUSE Labs
