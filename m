Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957061C1623
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgEANkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730965AbgEANkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:40:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED9F205C9;
        Fri,  1 May 2020 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340415;
        bh=JZaTmJJXTPqdDqVV9cglD1jNKO+CJtv6Qa925dntYME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPnj2WqLXQ8ys9ElcYg94FabFgTHDf71S4e+wuIlHvu0MrvOO4qceAzqHZY/CFBPZ
         t6JVU5h7k87sl3mDAQj+LGHEMt7ASY8QN1b0kJFD+jU541PtdcefDmvoztjXW7dReu
         0aVuyJVu2jvcjMBrxMEYX48D4dBN7jh3TejaAzgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/83] signal: check sig before setting info in kill_pid_usb_asyncio
Date:   Fri,  1 May 2020 15:23:35 +0200
Message-Id: <20200501131539.870805829@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit eaec2b0bd30690575c581eebffae64bfb7f684ac ]

In kill_pid_usb_asyncio, if signal is not valid, we do not need to
set info struct.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/f525fd08-1cf7-fb09-d20c-4359145eb940@huawei.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2b9295f2d2445..595a36ab87d02 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1510,15 +1510,15 @@ int kill_pid_usb_asyncio(int sig, int errno, sigval_t addr,
 	unsigned long flags;
 	int ret = -EINVAL;
 
+	if (!valid_signal(sig))
+		return ret;
+
 	clear_siginfo(&info);
 	info.si_signo = sig;
 	info.si_errno = errno;
 	info.si_code = SI_ASYNCIO;
 	*((sigval_t *)&info.si_pid) = addr;
 
-	if (!valid_signal(sig))
-		return ret;
-
 	rcu_read_lock();
 	p = pid_task(pid, PIDTYPE_PID);
 	if (!p) {
-- 
2.20.1



