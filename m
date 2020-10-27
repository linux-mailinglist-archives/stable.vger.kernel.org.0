Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8BF299E5D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408665AbgJ0AOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406915AbgJ0AL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7DF20791;
        Tue, 27 Oct 2020 00:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757489;
        bh=K2UUaSLNQyBICP48dxxnV3Rzi+dMsSPNYnRRZ736Fns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIisbK9Yz/mBvcQyrwLcUIK5yUvC+oEMyir71TsmrutGGAnufqiS+zu61YRJ0uJNA
         Q/zwn05stgfeQKXlJtNLizyWwnf+i9iL7pe14unAKk+TVM+g+/wtsQd+taErD1mPNX
         Mh+jsl6LUmSf+72tC6XGHwiNQ+3I2+mPHzPbaO5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 04/25] um: change sigio_spinlock to a mutex
Date:   Mon, 26 Oct 2020 20:11:02 -0400
Message-Id: <20201027001123.1027642-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.25.1

