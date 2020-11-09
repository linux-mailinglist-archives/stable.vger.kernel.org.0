Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B502ABD7D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgKINqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbgKIM5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:57:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C2782076E;
        Mon,  9 Nov 2020 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926655;
        bh=8IoPhvaNi50VZ4kDbgG2391J0F0bfxVrFVK+xANb+9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmooQyVrmm8PpiSjejs3dEpzo8UPE0p8SIpeS7QYem9qWqN7VZNBcnBhDeyfXXYEq
         2m4bc9JzftNjCvsX4MLU/ydXIWfFza60vognuxLT9ZYLAvPei3kkbnQwkK3B0IiEv9
         OJTJtRuw7fpJAozrTJYD6rl36k3BWJpTh+mF0H3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/86] um: change sigio_spinlock to a mutex
Date:   Mon,  9 Nov 2020 13:54:21 +0100
Message-Id: <20201109125021.546925982@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f2d05059e15af3f70502074f4e3a504530af504a ]

Lockdep complains at boot:

=============================
[ BUG: Invalid wait context ]
5.7.0-05093-g46d91ecd597b #98 Not tainted
-----------------------------
swapper/1 is trying to lock:
0000000060931b98 (&desc[i].request_mutex){+.+.}-{3:3}, at: __setup_irq+0x11d/0x623
other info that might help us debug this:
context-{4:4}
1 lock held by swapper/1:
 #0: 000000006074fed8 (sigio_spinlock){+.+.}-{2:2}, at: sigio_lock+0x1a/0x1c
stack backtrace:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0-05093-g46d91ecd597b #98
Stack:
 7fa4fab0 6028dfd1 0000002a 6008bea5
 7fa50700 7fa50040 7fa4fac0 6028e016
 7fa4fb50 6007f6da 60959c18 00000000
Call Trace:
 [<60023a0e>] show_stack+0x13b/0x155
 [<6028e016>] dump_stack+0x2a/0x2c
 [<6007f6da>] __lock_acquire+0x515/0x15f2
 [<6007eb50>] lock_acquire+0x245/0x273
 [<6050d9f1>] __mutex_lock+0xbd/0x325
 [<6050dc76>] mutex_lock_nested+0x1d/0x1f
 [<6008e27e>] __setup_irq+0x11d/0x623
 [<6008e8ed>] request_threaded_irq+0x169/0x1a6
 [<60021eb0>] um_request_irq+0x1ee/0x24b
 [<600234ee>] write_sigio_irq+0x3b/0x76
 [<600383ca>] sigio_broken+0x146/0x2e4
 [<60020bd8>] do_one_initcall+0xde/0x281

Because we hold sigio_spinlock and then get into requesting
an interrupt with a mutex.

Change the spinlock to a mutex to avoid that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sigio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/sigio.c b/arch/um/kernel/sigio.c
index b5e0cbb343828..476ded92affac 100644
--- a/arch/um/kernel/sigio.c
+++ b/arch/um/kernel/sigio.c
@@ -36,14 +36,14 @@ int write_sigio_irq(int fd)
 }
 
 /* These are called from os-Linux/sigio.c to protect its pollfds arrays. */
-static DEFINE_SPINLOCK(sigio_spinlock);
+static DEFINE_MUTEX(sigio_mutex);
 
 void sigio_lock(void)
 {
-	spin_lock(&sigio_spinlock);
+	mutex_lock(&sigio_mutex);
 }
 
 void sigio_unlock(void)
 {
-	spin_unlock(&sigio_spinlock);
+	mutex_unlock(&sigio_mutex);
 }
-- 
2.27.0



