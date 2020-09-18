Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1855B26F354
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgIRDF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbgIRCES (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D4723788;
        Fri, 18 Sep 2020 02:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394656;
        bh=BrIFdQk10NoUb6X1ATgRqNtGNFzWLv/ksH9Kyx983J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9Mlh8WftGesF/Ez45cDL8grZfZIhmJVAR2ZunOwpSwrBjnq0N5XmyLeEyuTBl6v5
         dDENmuzBcxBPSb6W3XLwzb41ke4z0z75z1syhwL19kmFipuojqH6GI0T166WDLPqGS
         Fs7SP5Rm5JjiFhLCPpL7+AUGr8ATy9fCv6AMKbIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 152/330] timekeeping: Prevent 32bit truncation in scale64_check_overflow()
Date:   Thu, 17 Sep 2020 21:58:12 -0400
Message-Id: <20200918020110.2063155-152-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index ca69290bee2a3..4fc2af4367a7b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1005,9 +1005,8 @@ static int scale64_check_overflow(u64 mult, u64 div, u64 *base)
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

