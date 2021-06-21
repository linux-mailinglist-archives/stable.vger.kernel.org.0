Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176AB3AED80
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhFUQUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhFUQUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A66361289;
        Mon, 21 Jun 2021 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292270;
        bh=dXoz8y2l5ilNqiLb4Stw0VTkhiHTcNOhwddVUpJemOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/K+8F0Yjb0d0CWxtAQDtW5Yg+rIAhpRdBAzVPK85kxFATweDJ5maEz9rRz6y0AXP
         xHu1G/lBD+kCkE6FL/5YIrJLZH5bG0OcwDxkc5IFiBHbFcQ3uaVNa4/dYsPR+IjZeq
         bOmxCbPHc3DTJtFPAt9NXR2CCkITFcY67E5ljep8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/90] ptp: improve max_adj check against unreasonable values
Date:   Mon, 21 Jun 2021 18:15:03 +0200
Message-Id: <20210621154905.071913255@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b84f16bbd6f2..eedf067ee8e3 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-s32 scaled_ppm_to_ppb(long ppm)
+long scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -80,7 +80,7 @@ s32 scaled_ppm_to_ppb(long ppm)
 	s64 ppb = 1 + ppm;
 	ppb *= 125;
 	ppb >>= 13;
-	return (s32) ppb;
+	return (long) ppb;
 }
 EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
@@ -138,7 +138,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
 	} else if (tx->modes & ADJ_FREQUENCY) {
-		s32 ppb = scaled_ppm_to_ppb(tx->freq);
+		long ppb = scaled_ppm_to_ppb(tx->freq);
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		if (ops->adjfine)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 93cc4f1d444a..874f7e73ed01 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -218,7 +218,7 @@ extern int ptp_clock_index(struct ptp_clock *ptp);
  * @ppm:    Parts per million, but with a 16 bit binary fractional field
  */
 
-extern s32 scaled_ppm_to_ppb(long ppm);
+extern long scaled_ppm_to_ppb(long ppm);
 
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
-- 
2.30.2



