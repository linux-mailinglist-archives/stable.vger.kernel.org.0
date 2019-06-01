Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED5C31F42
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfFANm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbfFANSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D37A272AA;
        Sat,  1 Jun 2019 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395118;
        bh=pSQ5DEHZaeS50AnylJCS2cJ1AN4jKrAS3LTuMoN8T04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZAox/OjnkQmBJ2Gaqga8Uw4rRCzt3j42hjfHhaxBBo9kGVFmDWj38XUiaFoo9R+O
         mIfVv2LE3COj8OpVx9hRsHyQtXIbrAI4r5GdHPBbEzEC4q8+XNeLN6VZ+TjK5vd9CY
         AgEXZLW48e1Zg+U3MJE+rody4P/p+rkAoReOSHfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 042/186] ntp: Allow TAI-UTC offset to be set to zero
Date:   Sat,  1 Jun 2019 09:14:18 -0400
Message-Id: <20190601131653.24205-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
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
index 92a90014a9252..f43d47c8c3b6c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -690,7 +690,7 @@ static inline void process_adjtimex_modes(const struct __kernel_timex *txc,
 		time_constant = max(time_constant, 0l);
 	}
 
-	if (txc->modes & ADJ_TAI && txc->constant > 0)
+	if (txc->modes & ADJ_TAI && txc->constant >= 0)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-- 
2.20.1

