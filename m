Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFB368D00
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbfGONzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732632AbfGONzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:37 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374FC217F9;
        Mon, 15 Jul 2019 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198937;
        bh=8SVyqH00Vk+wmUT3hi2IA4kgYubzOzW0NcN+Endh2fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaXr/nnay0sthHgSKYAFiiGlCpH5VkpnVK4EDM5+9UNun6I2tLn9uGkNhT6vFWp09
         NK3lKYyeOyBLyJ+r2YxF9+vtqECo0Sbpb+0y/H6YAC/0OPySLyeZfcqKTf3fOF8vOG
         slI1xCAU4EUki9ZC6jn07D9Bt2yUpG7KzOePx5d8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Weikang shi <swkhack@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 146/249] ntp: Limit TAI-UTC offset
Date:   Mon, 15 Jul 2019 09:45:11 -0400
Message-Id: <20190715134655.4076-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

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

