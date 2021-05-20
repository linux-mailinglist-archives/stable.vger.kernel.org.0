Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3205A38AA23
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhETLK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239380AbhETLHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E3561D37;
        Thu, 20 May 2021 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505159;
        bh=Mvf0FNLedeZuBsf1fMjib3KJj6PXlybLW9Ols/CrO0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSIBSyNa0Q8+QBwHd4dN69NJZPmU1Bo8h8AizoQfzMohetDh6eHwari4MJ8XNbk5G
         5QvaoUqhNHkvTu+DFtglTOfOM5njiteYFwnQtiDXHOSBJnntxrYfe4stM1yUhVrkn0
         EBQIu8PJgRyla69S1gQNlHTJRVPUsofdQPvChQ2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Caruso <ejcaruso@google.com>,
        Todd Poynor <toddpoynor@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kasper Zwijsen <Kasper.Zwijsen@UGent.be>
Subject: [PATCH 4.4 001/190] timerfd: Reject ALARM timerfds without CAP_WAKE_ALARM
Date:   Thu, 20 May 2021 11:21:05 +0200
Message-Id: <20210520092102.199503505@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Caruso <ejcaruso@google.com>

commit 2895a5e5b3ae78d9923a91fce405d4a2f32c4309 upstream.

timerfd gives processes a way to set wake alarms, but unlike timers made using
timer_create, timerfds don't check whether the process has CAP_WAKE_ALARM
before setting alarm-time timers. CAP_WAKE_ALARM is supposed to gate this
behavior and so it makes sense that we should deny permission to create such
timerfds if the process doesn't have this capability.

Signed-off-by: Eric Caruso <ejcaruso@google.com>
Cc: Todd Poynor <toddpoynor@google.com>
Link: http://lkml.kernel.org/r/1465427339-96209-1-git-send-email-ejcaruso@chromium.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kasper Zwijsen <Kasper.Zwijsen@UGent.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/timerfd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -400,6 +400,11 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	     clockid != CLOCK_BOOTTIME_ALARM))
 		return -EINVAL;
 
+	if (!capable(CAP_WAKE_ALARM) &&
+	    (clockid == CLOCK_REALTIME_ALARM ||
+	     clockid == CLOCK_BOOTTIME_ALARM))
+		return -EPERM;
+
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -444,6 +449,11 @@ static int do_timerfd_settime(int ufd, i
 		return ret;
 	ctx = f.file->private_data;
 
+	if (!capable(CAP_WAKE_ALARM) && isalarm(ctx)) {
+		fdput(f);
+		return -EPERM;
+	}
+
 	timerfd_setup_cancel(ctx, flags);
 
 	/*


