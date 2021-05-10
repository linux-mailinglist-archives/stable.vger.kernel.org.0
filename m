Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55A63783B3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhEJKrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhEJKou (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D44F61075;
        Mon, 10 May 2021 10:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642863;
        bh=SdSFpBpRgPfkm5XJGFFr1af15UgE2cUoz/UoKCzuSdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7mUHYRUE+DaDvScMn5B7Szc/vmxFVzpPHxJul5YrUnnIUIjlzWnQL+Eev9RnivoD
         odDXS3bjxo+nfaDxHgvUyawObksw7sb52aCOPNyVI0TviCvB/Ydfrbf2c27dxM5VCZ
         wymGT53ab5RoneY0m/SAcuwQwxVJQQ/rbY/IDLbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Jun <chenjun102@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 5.10 048/299] posix-timers: Preserve return value in clock_adjtime32()
Date:   Mon, 10 May 2021 12:17:25 +0200
Message-Id: <20210510102006.451877033@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
@@ -1191,8 +1191,8 @@ SYSCALL_DEFINE2(clock_adjtime32, clockid
 
 	err = do_clock_adjtime(which_clock, &ktx);
 
-	if (err >= 0)
-		err = put_old_timex32(utp, &ktx);
+	if (err >= 0 && put_old_timex32(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }


