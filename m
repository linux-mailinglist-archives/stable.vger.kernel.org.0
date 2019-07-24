Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD6473C2D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392705AbfGXUFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392698AbfGXUFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:05:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24314205C9;
        Wed, 24 Jul 2019 20:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998734;
        bh=9HkI8KqjkQAT7iiy/6DmWYzMfKjpFbzT9axjyxWvP9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzaIhedYNAFBg9vcLNBPIbOjUWBxspUtMEnK8DvEr8cDw/FpUX3InKJGpkD3CrZgK
         ipMAFITh40Ow8GfJj0ukEQTnWs7Yt8RD8Ep2RBx1Eht18y09Qp2Njvk215R7GxUTlc
         XJTFfDoqDSzN1sgwb/9YygXi374SCl9s0rTPmcB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weikang shi <swkhack@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/271] ntp: Limit TAI-UTC offset
Date:   Wed, 24 Jul 2019 21:19:25 +0200
Message-Id: <20190724191703.450212234@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d897a4ab11dc8a9fda50d2eccc081a96a6385998 ]

Don't allow the TAI-UTC offset of the system clock to be set by adjtimex()
to a value larger than 100000 seconds.

This prevents an overflow in the conversion to int, prevents the CLOCK_TAI
clock from getting too far ahead of the CLOCK_REALTIME clock, and it is
still large enough to allow leap seconds to be inserted at the maximum rate
currently supported by the kernel (once per day) for the next ~270 years,
however unlikely it is that someone can survive a catastrophic event which
slowed down the rotation of the Earth so much.

Reported-by: Weikang shi <swkhack@gmail.com>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190618154713.20929-1-mlichvar@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/ntp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 6b23cd584295..e1110a7bd3e6 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -43,6 +43,7 @@ static u64			tick_length_base;
 #define MAX_TICKADJ		500LL		/* usecs */
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
+#define MAX_TAI_OFFSET		100000
 
 /*
  * phase-lock loop variables
@@ -698,7 +699,8 @@ static inline void process_adjtimex_modes(const struct timex *txc, s32 *time_tai
 		time_constant = max(time_constant, 0l);
 	}
 
-	if (txc->modes & ADJ_TAI && txc->constant >= 0)
+	if (txc->modes & ADJ_TAI &&
+			txc->constant >= 0 && txc->constant <= MAX_TAI_OFFSET)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-- 
2.20.1



