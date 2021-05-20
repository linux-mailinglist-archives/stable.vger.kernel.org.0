Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD638A2C6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhETJpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhETJni (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6EB8613CC;
        Thu, 20 May 2021 09:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503175;
        bh=zGmGGO0XA5Pmfgp9otxjfakQ8M9SgKuKBVusmyeMx1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxgWoNJuVkt/f489gsYi3n0r7KNhlCHdIQSDDvGGhHu4QlhRplCU2ZczYlmmRLdYQ
         NniNK7ZxQbAj0lJOWyc+Jkmu8MC14ZAj39U18ULSEc2FFB6/zaP04fej1hoBbqrkEu
         NIOxU59U0J2e61DaozssUcvUiTX/K+zXBUgSp2Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 4.19 101/425] posix-timers: Preserve return value in clock_adjtime32()
Date:   Thu, 20 May 2021 11:17:50 +0200
Message-Id: <20210520092134.775438530@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -1166,8 +1166,8 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, cl
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (err >= 0)
-		err = compat_put_timex(utp, &ktx);
+	if (err >= 0 && compat_put_timex(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }


