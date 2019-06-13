Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6245544359
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392157AbfFMQ2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730938AbfFMIfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:35:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 836A9206E0;
        Thu, 13 Jun 2019 08:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414932;
        bh=3vPlgZNd7nYVW3NeAqRwuF3YuCgseMLE4XA7E4HD1mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXCXlstGx5n0tK1aNPqYoEyGDq8FP/Qt9kb4KeFZpH4dKAb7FOvoUWMBBPlObYEXZ
         IvkvWiRlQtKUtmJdzMXuk6nm4KkDiDOxndG7tsRSCYo5t27n7M7J7lB1YVSTapJMyp
         16Svozn0KY2mnvxtJHYvdER5KID9F+TYslwZP+lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/81] ntp: Allow TAI-UTC offset to be set to zero
Date:   Thu, 13 Jun 2019 10:33:08 +0200
Message-Id: <20190613075650.991287714@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 99e03bec68e4..4bb9b66338be 100644
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



