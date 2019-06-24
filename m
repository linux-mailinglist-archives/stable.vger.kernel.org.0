Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E444350897
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfFXKPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbfFXKPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:15:42 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6456A2089F;
        Mon, 24 Jun 2019 10:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371341;
        bh=6OdPh8UvNgFw9kAu6ULVURDzR2ajJLVxWU0NRDBdpe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/QllV4T15nfPeq9EY5tYSi16iLAylaiJY1d6mSaDTaD+9wIYSQUEddMbVVqEdkGY
         zRabsYg1U52ipTsaCbZazBtfQHYCdOtsabNh2V+Ljj7GjW0XvkW+Fu/tTG4YvSpKp8
         PyfVTBSkKbYFAuP/wXTHk8oVgkU4HyTzHHPsovXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 066/121] sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD
Date:   Mon, 24 Jun 2019 17:56:38 +0800
Message-Id: <20190624092324.192490402@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



