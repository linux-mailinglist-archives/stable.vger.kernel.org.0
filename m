Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0410131C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfKSFW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbfKSFW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C444121939;
        Tue, 19 Nov 2019 05:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140946;
        bh=qhjc3em040Ekybk+oPPE0CRElY/YwmptLb2RMbz5b94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vos8Duf10v0ZOXfPiVPqT1uRGRPyyuk1H7S+SrRGTffQ0e7pFJp22M8jHKjOXiC1w
         nW01Ep+mxA2Kzx0DNfTotBnclHqyNNcM3wPu0EeBUIHK6IAQfU2v0xz3iGIJkyrIeH
         D9RYE/4AcHqAhiEScz7iJ0zvtdo1YiP9vMecjYIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.3 39/48] ntp/y2038: Remove incorrect time_t truncation
Date:   Tue, 19 Nov 2019 06:19:59 +0100
Message-Id: <20191119051022.161704534@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2f5841349df281ecf8f81cc82d869b8476f0db0b upstream.

A cast to 'time_t' was accidentally left in place during the
conversion of __do_adjtimex() to 64-bit timestamps, so the
resulting value is incorrectly truncated.

Remove the cast so the 64-bit time gets propagated correctly.

Fixes: ead25417f82e ("timex: use __kernel_timex internally")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191108203435.112759-2-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -771,7 +771,7 @@ int __do_adjtimex(struct __kernel_timex
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	txc->time.tv_sec = (time_t)ts->tv_sec;
+	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec = ts->tv_nsec / NSEC_PER_USEC;


