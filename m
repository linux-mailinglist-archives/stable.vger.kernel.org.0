Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041FC27C8FF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgI2MGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C57023AAC;
        Tue, 29 Sep 2020 11:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379401;
        bh=BrIFdQk10NoUb6X1ATgRqNtGNFzWLv/ksH9Kyx983J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQOj4xL8CtzFwiWcfRl/+R6RoXt6cdZduLiBV24pvwccZNrx2jKWiPtjm3XdHTyuT
         RGzuU53O/duQordq4dJQw8uRI28fj91X3kCF4x8Zq2OaUAiLzhyZleYqT52OQHqr2u
         QXbV94eYM7kLsDDHDyBdM7YdqkpOJYzlQgLWDEyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/388] timekeeping: Prevent 32bit truncation in scale64_check_overflow()
Date:   Tue, 29 Sep 2020 12:57:57 +0200
Message-Id: <20200929110017.540703166@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



