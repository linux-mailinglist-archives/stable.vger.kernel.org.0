Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94234C602
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhC2IEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhC2IDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A84E619CA;
        Mon, 29 Mar 2021 08:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005012;
        bh=WWKK9RxNWAXgPCH7HSSLdGqI22JLNNmpgwz5y6Abp2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gw+zIS9+1jp61bDfKXikSGxhU91TZuySGQkKoTysDHbit2YfS0r/Pqjj4eYLTJgjs
         QtXqVMbJNc7M+aJhZaBzsQPp/BWMMavPbi7s+Knk+hEeMuVT6BObo/fpLdrlp3dZty
         4RC4uelScmZ49gOvXnHrw4Ul2thIrU5LKxGfxOho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mateusz Nosek <mateusznosek0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 48/53] futex: Fix incorrect should_fail_futex() handling
Date:   Mon, 29 Mar 2021 09:58:23 +0200
Message-Id: <20210329075609.096873496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>

commit 921c7ebd1337d1a46783d7e15a850e12aed2eaa0 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1605,8 +1605,10 @@ static int wake_futex_pi(u32 __user *uad
 	 */
 	newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
-	if (unlikely(should_fail_futex(true)))
+	if (unlikely(should_fail_futex(true))) {
 		ret = -EFAULT;
+		goto out_unlock;
+	}
 
 	ret = cmpxchg_futex_value_locked(&curval, uaddr, uval, newval);
 	if (!ret && (curval != uval)) {


