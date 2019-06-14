Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36CB46A40
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfFNUg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfFNU3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:40 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DA82184B;
        Fri, 14 Jun 2019 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544179;
        bh=KKYH9BGJ4VGKUCyRJKTlgi3ZCPu5H0tuZNbJsslSLw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zoVQAQzW+aPveniH704Bcz1PS8BkkLc23zskoydff9FUXgEBeHtOrowbDuOrrNjsr
         8EHXvL4ABN2cJWUGz97wDH50cZU/aTCgzCDp0LXUr/bOLy7NQCYjl1vUmuwElFIPj1
         7r1Zd3rMxEapwlKDP1hgo45KMzdH0GXQ4hezJOBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 37/59] sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD
Date:   Fri, 14 Jun 2019 16:28:21 -0400
Message-Id: <20190614202843.26941-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>

[ Upstream commit 56cd0aefa475079e9613085b14a0f05037518fed ]

The PERF_EVENT_IOC_PERIOD ioctl command can be used to change the
sample period of a running perf_event. Consequently, when calculating
the next event period, the new period will only be considered after the
previous one has overflowed.

This patch changes the calculation of the remaining event ticks so that
they are offset if the period has changed.

See commit 3581fe0ef37c ("ARM: 7556/1: perf: fix updated event period in
response to PERF_EVENT_IOC_PERIOD") for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/perf_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 6de7c684c29f..a58ae9c42803 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -891,6 +891,10 @@ static int sparc_perf_event_set_period(struct perf_event *event,
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
+	/* The period may have been changed by PERF_EVENT_IOC_PERIOD */
+	if (unlikely(period != hwc->last_period))
+		left = period - (hwc->last_period - left);
+
 	if (unlikely(left <= -period)) {
 		left = period;
 		local64_set(&hwc->period_left, left);
-- 
2.20.1

