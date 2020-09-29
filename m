Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A4E27C4AB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgI2LPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729531AbgI2LPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:15:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01505206A5;
        Tue, 29 Sep 2020 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378137;
        bh=KEdDaj2rl9n492aoW3xE+uz9UJM/LdYdz/Y1IXG2eU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycaqUFsucIf6u3QHjOsyB5kT8sJsELs8OGVuxRg6URCTjuqsuvECULz2WrJcWSYtj
         dfSfND/gwJwS7VoXszUUYYV8nbMKpWF80901R+XTcvEoPfHOgxO9WplKlH9tvKD2QO
         ZO4/9Vl0jKzv9uVwCxXYMzfC5m6zKyDOFpb9WRa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/166] timekeeping: Prevent 32bit truncation in scale64_check_overflow()
Date:   Tue, 29 Sep 2020 12:59:46 +0200
Message-Id: <20200929105938.915539331@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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



