Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950A073F57
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfGXT3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbfGXT3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:29:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01512229F4;
        Wed, 24 Jul 2019 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996572;
        bh=V8pqFtYmPbi27eoOXAf9Q5m8rG6d3UHFvMHgXPeYqgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byk/bEfhMyL2k6g39sf9gKLESVB/kjpFRd3ijIbl0fGsuLnQjb5Oj3gQlL6N9wSkY
         LnrPPrHXGAGVMHK1xfEFvOSbduZ8pHp7pIchxc/DlNcwe46ezpiElF7lOHlH1Qb1Tf
         DQI3v2M7B8ygYxA7kRH1kHB9uNCBfcyhuvFY42AM=
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
Subject: [PATCH 5.2 143/413] ntp: Limit TAI-UTC offset
Date:   Wed, 24 Jul 2019 21:17:14 +0200
Message-Id: <20190724191745.190143578@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
index 8de4f789dc1b..65eb796610dc 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -43,6 +43,7 @@ static u64			tick_length_base;
 #define MAX_TICKADJ		500LL		/* usecs */
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
+#define MAX_TAI_OFFSET		100000
 
 /*
  * phase-lock loop variables
@@ -691,7 +692,8 @@ static inline void process_adjtimex_modes(const struct __kernel_timex *txc,
 		time_constant = max(time_constant, 0l);
 	}
 
-	if (txc->modes & ADJ_TAI && txc->constant >= 0)
+	if (txc->modes & ADJ_TAI &&
+			txc->constant >= 0 && txc->constant <= MAX_TAI_OFFSET)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-- 
2.20.1



