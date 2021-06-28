Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA453B62C9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhF1Ot2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhF1On0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F9DE61D01;
        Mon, 28 Jun 2021 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890826;
        bh=x5eHzrd524X4z6GjnlPVRaelHBTUcH6/miCGCrq7OGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amPRHmf+Vx6iK1MgVMYkJOwIXJnBTYxdq29joT3TWSiTS87FaaufyP9u1C3gTO0Qw
         GwWMBLwa13XLRcDl6PYTWJhukODL+sUy0LGkGbGAPtLZVu8kqijWYb9/ecjYKDFH6b
         YEerxHO06wQhitPuUyY1sBmo3ZeAhb/V4PC7b1u6HCzDri7WrEETxclmH3XsOLHWnC
         SYQ4YGpPGFaszuf1ZUNlOaMFem6qitxNKTeSPb8R5LY7wdMzYBuTKj8BXFEpVs+tnX
         upDL7Z8AG5RXf2bQg3RL2p9Tch+oknlgsjp54YMpqhU74HN1aVwNKDQ/MxwJxf2El0
         SrWK+lJvnWIsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/109] ptp: improve max_adj check against unreasonable values
Date:   Mon, 28 Jun 2021 10:31:59 -0400
Message-Id: <20210628143305.32978-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 475b92f932168a78da8109acd10bfb7578b8f2bb ]

Scaled PPM conversion to PPB may (on 64bit systems) result
in a value larger than s32 can hold (freq/scaled_ppm is a long).
This means the kernel will not correctly reject unreasonably
high ->freq values (e.g. > 4294967295ppb, 281474976645 scaled PPM).

The conversion is equivalent to a division by ~66 (65.536),
so the value of ppb is always smaller than ppm, but not small
enough to assume narrowing the type from long -> s32 is okay.

Note that reasonable user space (e.g. ptp4l) will not use such
high values, anyway, 4289046510ppb ~= 4.3x, so the fix is
somewhat pedantic.

Fixes: d39a743511cd ("ptp: validate the requested frequency adjustment.")
Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c          | 6 +++---
 include/linux/ptp_clock_kernel.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 863958f3bb57..89632cc9c28f 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -76,7 +76,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-s32 scaled_ppm_to_ppb(long ppm)
+long scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -93,7 +93,7 @@ s32 scaled_ppm_to_ppb(long ppm)
 	s64 ppb = 1 + ppm;
 	ppb *= 125;
 	ppb >>= 13;
-	return (s32) ppb;
+	return (long) ppb;
 }
 EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
@@ -148,7 +148,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct timex *tx)
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
 	} else if (tx->modes & ADJ_FREQUENCY) {
-		s32 ppb = scaled_ppm_to_ppb(tx->freq);
+		long ppb = scaled_ppm_to_ppb(tx->freq);
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		if (ops->adjfine)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 40ea83fcfdd5..99c3f4ee938e 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -210,7 +210,7 @@ extern int ptp_clock_index(struct ptp_clock *ptp);
  * @ppm:    Parts per million, but with a 16 bit binary fractional field
  */
 
-extern s32 scaled_ppm_to_ppb(long ppm);
+extern long scaled_ppm_to_ppb(long ppm);
 
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
-- 
2.30.2

