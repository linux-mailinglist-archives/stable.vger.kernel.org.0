Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F583C4B24
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239289AbhGLGzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237708AbhGLGzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86ECE60FD8;
        Mon, 12 Jul 2021 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072741;
        bh=fob3s5mDsTJVZqnRf2jvmECc0ABXF+X68QEkJbejXo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8rqnD4/7Fo1W9h44PmFUUxWR886SjfEz+gtwPNhaA7VtJjLEOz+qgUrEJBYw0SO7
         2m6ZLku9DocgG++H/nLncd+dxfykK09Nsxo3BQ7d7tfuLjE9FMkKYDd/6nAijlZfQL
         6Z7LO/BIp/qyTxysssFTvAiERcKgt1bAPIJ3UwIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Yiyuan Guo <yguoaz@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oskar Schirmer <oskar@scara.com>,
        Daniel Latypov <dlatypov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 573/593] lib/math/rational.c: fix divide by zero
Date:   Mon, 12 Jul 2021 08:12:13 +0200
Message-Id: <20210712060958.032686275@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trent Piepho <tpiepho@gmail.com>

[ Upstream commit 65a0d3c14685663ba111038a35db70f559e39336 ]

If the input is out of the range of the allowed values, either larger than
the largest value or closer to zero than the smallest non-zero allowed
value, then a division by zero would occur.

In the case of input too large, the division by zero will occur on the
first iteration.  The best result (largest allowed value) will be found by
always choosing the semi-convergent and excluding the denominator based
limit when finding it.

In the case of the input too small, the division by zero will occur on the
second iteration.  The numerator based semi-convergent should not be
calculated to avoid the division by zero.  But the semi-convergent vs
previous convergent test is still needed, which effectively chooses
between 0 (the previous convergent) vs the smallest allowed fraction (best
semi-convergent) as the result.

Link: https://lkml.kernel.org/r/20210525144250.214670-1-tpiepho@gmail.com
Fixes: 323dd2c3ed0 ("lib/math/rational.c: fix possible incorrect result from rational fractions helper")
Signed-off-by: Trent Piepho <tpiepho@gmail.com>
Reported-by: Yiyuan Guo <yguoaz@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Oskar Schirmer <oskar@scara.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/math/rational.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/lib/math/rational.c b/lib/math/rational.c
index 9781d521963d..c0ab51d8fbb9 100644
--- a/lib/math/rational.c
+++ b/lib/math/rational.c
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/minmax.h>
+#include <linux/limits.h>
 
 /*
  * calculate best rational approximation for a given fraction
@@ -78,13 +79,18 @@ void rational_best_approximation(
 		 * found below as 't'.
 		 */
 		if ((n2 > max_numerator) || (d2 > max_denominator)) {
-			unsigned long t = min((max_numerator - n0) / n1,
-					      (max_denominator - d0) / d1);
+			unsigned long t = ULONG_MAX;
 
-			/* This tests if the semi-convergent is closer
-			 * than the previous convergent.
+			if (d1)
+				t = (max_denominator - d0) / d1;
+			if (n1)
+				t = min(t, (max_numerator - n0) / n1);
+
+			/* This tests if the semi-convergent is closer than the previous
+			 * convergent.  If d1 is zero there is no previous convergent as this
+			 * is the 1st iteration, so always choose the semi-convergent.
 			 */
-			if (2u * t > a || (2u * t == a && d0 * dp > d1 * d)) {
+			if (!d1 || 2u * t > a || (2u * t == a && d0 * dp > d1 * d)) {
 				n1 = n0 + t * n1;
 				d1 = d0 + t * d1;
 			}
-- 
2.30.2



