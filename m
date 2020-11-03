Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24E2A514A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgKCUj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730001AbgKCUiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C10522226;
        Tue,  3 Nov 2020 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435925;
        bh=5kTtZJ6ivM0+AQ5KYxTiwY4HRc6SBoPErjLnWujXEPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmGU3oBqSFoqaPJ1s0ixrIVMckj4m/NZjq4x1CJuN9TtisKdj84JeIpgIKAgbaIgD
         nyASIkblZ48S/G8CLINqga/HwFxWsXIdH7HZP4d+GLsRqx092sONte2VH1SkxP0liP
         3Ypg+xvcfnTQz+10zfAc49fc/qdqjg+dMaVRecbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mateusz Nosek <mateusznosek0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 042/391] futex: Fix incorrect should_fail_futex() handling
Date:   Tue,  3 Nov 2020 21:31:33 +0100
Message-Id: <20201103203350.464441080@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>

[ Upstream commit 921c7ebd1337d1a46783d7e15a850e12aed2eaa0 ]

If should_futex_fail() returns true in futex_wake_pi(), then the 'ret'
variable is set to -EFAULT and then immediately overwritten. So the failure
injection is non-functional.

Fix it by actually leaving the function and returning -EFAULT.

The Fixes tag is kinda blury because the initial commit which introduced
failure injection was already sloppy, but the below mentioned commit broke
it completely.

[ tglx: Massaged changelog ]

Fixes: 6b4f4bc9cb22 ("locking/futex: Allow low-level atomic operations to return -EAGAIN")
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20200927000858.24219-1-mateusznosek0@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a5876694a60eb..39681bf8b06ca 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1502,8 +1502,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_pi_state *pi_
 	 */
 	newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
-	if (unlikely(should_fail_futex(true)))
+	if (unlikely(should_fail_futex(true))) {
 		ret = -EFAULT;
+		goto out_unlock;
+	}
 
 	ret = cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
 	if (!ret && (curval != uval)) {
-- 
2.27.0



