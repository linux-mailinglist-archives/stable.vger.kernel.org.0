Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B4331DF4
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfFANYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbfFANYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:24:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A303327385;
        Sat,  1 Jun 2019 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395481;
        bh=69y2gItOvSr9OXGYmGzI3KvaoNkcFXtW1WXboLzi4RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltIr17fL6bULozUshRH4CUsDM1F4q29LL9/+G9fbZ6SpYxK9pT649TKUKC2WmNIJu
         bJtJ8VvqGq1H3zaIvvV3pRNsUwUtwHk+97YD1TLnrXQ5w6jOisYfkM6SQIATNdHS/v
         q2nCIMgsnBsgfPWOJ29iNHpZBal37evWsDGOs7Ts=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 26/99] ntp: Allow TAI-UTC offset to be set to zero
Date:   Sat,  1 Jun 2019 09:22:33 -0400
Message-Id: <20190601132346.26558-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132346.26558-1-sashal@kernel.org>
References: <20190601132346.26558-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit fdc6bae940ee9eb869e493990540098b8c0fd6ab ]

The ADJ_TAI adjtimex mode sets the TAI-UTC offset of the system clock.
It is typically set by NTP/PTP implementations and it is automatically
updated by the kernel on leap seconds. The initial value is zero (which
applications may interpret as unknown), but this value cannot be set by
adjtimex. This limitation seems to go back to the original "nanokernel"
implementation by David Mills.

Change the ADJ_TAI check to accept zero as a valid TAI-UTC offset in
order to allow setting it back to the initial value.

Fixes: 153b5d054ac2 ("ntp: support for TAI")
Suggested-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: https://lkml.kernel.org/r/20190417084833.7401-1-mlichvar@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/ntp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 99e03bec68e4c..4bb9b66338bee 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -640,7 +640,7 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		time_constant = max(time_constant, 0l);
 	}
 
-	if (txc->modes & ADJ_TAI && txc->constant > 0)
+	if (txc->modes & ADJ_TAI && txc->constant >= 0)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-- 
2.20.1

