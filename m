Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0978538A635
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbhETKZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234457AbhETKWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 215A1619D4;
        Thu, 20 May 2021 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504098;
        bh=TNFGLE41deNXpFTTV+sZEvpI3K7lP4goVatkmxZkkjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnFR4IFPYK3Hb6bQFrkaxrGNMRXfPrj9DdbhPsZMHh2S0/KTqRGG/OmlkoI61d0Ly
         L+8TIx0Yx7LvQid1dj4ufSapAVShoddqfG+8vDcdOVJl5+pEnjB/1UXVZozCRMylRf
         XruZbOubAPzwRM296OpMaGhJqCjeMvSPyDOS3fHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 4.14 090/323] posix-timers: Preserve return value in clock_adjtime32()
Date:   Thu, 20 May 2021 11:19:42 +0200
Message-Id: <20210520092123.176548218@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -1172,8 +1172,8 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, cl
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (err >= 0)
-		err = compat_put_timex(utp, &ktx);
+	if (err >= 0 && compat_put_timex(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }


