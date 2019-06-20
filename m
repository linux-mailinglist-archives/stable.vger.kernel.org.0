Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075A24D94B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFTR61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfFTR6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:58:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F68208CA;
        Thu, 20 Jun 2019 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053505;
        bh=Q3Y+jTMtwJ6igER/h8jL54dZxpdJqUUZCd15E/OgiYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbzbrKLhFOipFxjvmZLW5NppCZ9CUYPD0fRt7AZ/EHsR5AuTick0hnmYbWJPrl9Sv
         Te7gGQWjx5IVyTMHBSKghu9bOqFNuUzVBc9xjbKbZ1opxujTYpcmtRsK8LpxlMNP0O
         U9zl7qW9zhJOg4PnTPV2AINNORiT5WonEIjjjfVY=
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
Subject: [PATCH 4.4 12/84] ntp: Allow TAI-UTC offset to be set to zero
Date:   Thu, 20 Jun 2019 19:56:09 +0200
Message-Id: <20190620174339.252672771@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
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
index ab861771e37f..0e0dc5d89911 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -633,7 +633,7 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		time_constant = max(time_constant, 0l);
 	}
 
-	if (txc->modes & ADJ_TAI && txc->constant > 0)
+	if (txc->modes & ADJ_TAI && txc->constant >= 0)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-- 
2.20.1



