Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65FE4093E8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345020AbhIMOZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345712AbhIMOW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:22:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 839E761A8F;
        Mon, 13 Sep 2021 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540871;
        bh=AO33QXA2qI7bkkbxNCXmBfdIcH625xh+knSBmMfrrJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Th23PvSb+6Ht7EfYhcD207Azxcai9VpNkl7srGZmRVpP7vrUiUXtiC+I1UIYOrDfk
         SCimZZ51qjIMAtYImDvjQizPN5iPR/yVl7gGW0j1PFNywUkPp+yb8xeagwRnihgeuy
         Jy963ualIwur77ENh0Df6gCx8U7hxMlnGKOSh1IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/334] genirq/timings: Fix error return code in irq_timings_test_irqs()
Date:   Mon, 13 Sep 2021 15:11:55 +0200
Message-Id: <20210913131115.478595839@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 290fdc4b7ef14e33d0e30058042b0e9bfd02b89b ]

Return a negative error code from the error handling case instead of 0, as
done elsewhere in this function.

Fixes: f52da98d900e ("genirq/timings: Add selftest for irqs circular buffer")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210811093333.2376-1-thunder.leizhen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/timings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/timings.c b/kernel/irq/timings.c
index 4d2a702d7aa9..c43e2ac2f8de 100644
--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -799,12 +799,14 @@ static int __init irq_timings_test_irqs(struct timings_intervals *ti)
 
 		__irq_timings_store(irq, irqs, ti->intervals[i]);
 		if (irqs->circ_timings[i & IRQ_TIMINGS_MASK] != index) {
+			ret = -EBADSLT;
 			pr_err("Failed to store in the circular buffer\n");
 			goto out;
 		}
 	}
 
 	if (irqs->count != ti->count) {
+		ret = -ERANGE;
 		pr_err("Count differs\n");
 		goto out;
 	}
-- 
2.30.2



