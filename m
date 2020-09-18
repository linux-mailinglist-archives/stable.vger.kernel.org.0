Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E031926EF49
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgIRCeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgIRCN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18DAF23447;
        Fri, 18 Sep 2020 02:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395208;
        bh=KEdDaj2rl9n492aoW3xE+uz9UJM/LdYdz/Y1IXG2eU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COsuqohrOHoi2t6U3G8ePGNQx2alhqNHjSwC3H8XkGOeTwGGNjjhpQxiswcMbvZCG
         5xXf+EkQSwkFJjE7qkfQwdU1qD46z2s0YxYovMn9Cpwa6eRM51gIOb3vTJ5kJ+CdoB
         d8xFBB37rVAiw341nb2L2VJN2cVXUa4v+47uj6uc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 057/127] timekeeping: Prevent 32bit truncation in scale64_check_overflow()
Date:   Thu, 17 Sep 2020 22:11:10 -0400
Message-Id: <20200918021220.2066485-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 4cbbc3a0eeed675449b1a4d080008927121f3da3 ]

While unlikely the divisor in scale64_check_overflow() could be >= 32bit in
scale64_check_overflow(). do_div() truncates the divisor to 32bit at least
on 32bit platforms.

Use div64_u64() instead to avoid the truncation to 32-bit.

[ tglx: Massaged changelog ]

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200120100523.45656-1-wenyang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1ce7c404d0b03..5b6f815a74ee3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -988,9 +988,8 @@ static int scale64_check_overflow(u64 mult, u64 div, u64 *base)
 	    ((int)sizeof(u64)*8 - fls64(mult) < fls64(rem)))
 		return -EOVERFLOW;
 	tmp *= mult;
-	rem *= mult;
 
-	do_div(rem, div);
+	rem = div64_u64(rem * mult, div);
 	*base = tmp + rem;
 	return 0;
 }
-- 
2.25.1

