Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C016637816A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhEJK0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhEJK0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B126146E;
        Mon, 10 May 2021 10:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642293;
        bh=1OJ1o49DtQeHif5CI2du50uyWvs18e90yIwqP4KFq3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCrwmxKwFYHpFbmB/luLXFNPOWxXSjcdpCTESPy8wm7ZW20rlPMVCq/1qqb1EYTfP
         F7ANQEYuRwAyqL/wdWhWwWXY1U8FMsmh3PUd8O2U+RPkav8w9SUBHMpfqRNpBg0w0w
         DVs10KpZuUW268sOo2TNRWL6Jh3ybsGuelYN/dkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 5.4 036/184] posix-timers: Preserve return value in clock_adjtime32()
Date:   Mon, 10 May 2021 12:18:50 +0200
Message-Id: <20210510101951.403809343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

commit 2d036dfa5f10df9782f5278fc591d79d283c1fad upstream.

The return value on success (>= 0) is overwritten by the return value of
put_old_timex32(). That works correct in the fault case, but is wrong for
the success case where put_old_timex32() returns 0.

Just check the return value of put_old_timex32() and return -EFAULT in case
it is not zero.

[ tglx: Massage changelog ]

Fixes: 3a4d44b61625 ("ntp: Move adjtimex related compat syscalls to native counterparts")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414030449.90692-1-chenjun102@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-timers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1169,8 +1169,8 @@ SYSCALL_DEFINE2(clock_adjtime32, clockid
 
 	err = do_clock_adjtime(which_clock, &ktx);
 
-	if (err >= 0)
-		err = put_old_timex32(utp, &ktx);
+	if (err >= 0 && put_old_timex32(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }


