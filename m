Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A233226EE3D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIRC04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgIRCPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D22152396F;
        Fri, 18 Sep 2020 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395351;
        bh=8o9zybgIuHAYYolfy9YI06KREygAviigU0xC/9gLius=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8qoOm6zNWPuo9Bp40Hw1Qm3L4oVf6O/6b3pyoWf0m81pZzj7lXBbDxJnEF5U8DPn
         +GODJiPHHt1aEatjrgqiD+dqqtTW290GCadrYapB8wCk65sHoyFDb1T4P14/C6lNYB
         aPjY+ScfVReG/6y+C5ofnR6JCrV9DxHUS7a3pKsM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 46/90] timekeeping: Prevent 32bit truncation in scale64_check_overflow()
Date:   Thu, 17 Sep 2020 22:14:11 -0400
Message-Id: <20200918021455.2067301-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
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
index e24e1f0c56906..e21b4d8b72405 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -950,9 +950,8 @@ static int scale64_check_overflow(u64 mult, u64 div, u64 *base)
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

