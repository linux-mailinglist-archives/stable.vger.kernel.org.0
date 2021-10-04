Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D0421011
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhJDNk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238546AbhJDNin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E42063244;
        Mon,  4 Oct 2021 13:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353466;
        bh=QP6nuaR1+mibQHUtOSz7uF/n+aPPer/THWb1NdvRCiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM28vPJidOfX97HBD3ina9Z+ClR39tWGoQJrbA7w0wP03O7T5QZ5UwvruPnoN7opw
         nv93O0OORWh5PsW2k7g+Ki6JiI0yL3kM9h2Rvg16P6B9UEE/x62fLo43S//RMXOsy/
         4uLpQFKwMAvhZAzA66DadHhJJ/OCDfQIlYKssFD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 140/172] sched/fair: Null terminate buffer when updating tunable_scaling
Date:   Mon,  4 Oct 2021 14:53:10 +0200
Message-Id: <20211004125049.493620907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit 703066188f63d66cc6b9d678e5b5ef1213c5938e ]

This patch null-terminates the temporary buffer in sched_scaling_write()
so kstrtouint() does not return failure and checks the value is valid.

Before:
  $ cat /sys/kernel/debug/sched/tunable_scaling
  1
  $ echo 0 > /sys/kernel/debug/sched/tunable_scaling
  -bash: echo: write error: Invalid argument
  $ cat /sys/kernel/debug/sched/tunable_scaling
  1

After:
  $ cat /sys/kernel/debug/sched/tunable_scaling
  1
  $ echo 0 > /sys/kernel/debug/sched/tunable_scaling
  $ cat /sys/kernel/debug/sched/tunable_scaling
  0
  $ echo 3 > /sys/kernel/debug/sched/tunable_scaling
  -bash: echo: write error: Invalid argument

Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20210927114635.GH3959@techsingularity.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7e08e3d947c2..2c879cd02a5f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -173,16 +173,22 @@ static ssize_t sched_scaling_write(struct file *filp, const char __user *ubuf,
 				   size_t cnt, loff_t *ppos)
 {
 	char buf[16];
+	unsigned int scaling;
 
 	if (cnt > 15)
 		cnt = 15;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
-	if (kstrtouint(buf, 10, &sysctl_sched_tunable_scaling))
+	if (kstrtouint(buf, 10, &scaling))
 		return -EINVAL;
 
+	if (scaling >= SCHED_TUNABLESCALING_END)
+		return -EINVAL;
+
+	sysctl_sched_tunable_scaling = scaling;
 	if (sched_update_scaling())
 		return -EINVAL;
 
-- 
2.33.0



