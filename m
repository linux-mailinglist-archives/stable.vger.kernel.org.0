Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C016E4522E0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378666AbhKPBQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244659AbhKOTRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D523F60C4A;
        Mon, 15 Nov 2021 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000565;
        bh=XmzqHL0Z0tJSw6FXl0JzN3xJCCpGMGmK9Cp/EP+0nkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/sF9VPlJv/On9LmOOTsYWP1jAlUtm8yF6Xs6+cUeGRBgOxa5GyLKzv4zhyUe8kGd
         QaMuCqm3H6GmePEwdAuPhu2SBCo+a/IdftTjqLxhBkni1QxF+mHpw1C0onS36miZr6
         G7jgV0y1H5WFAkuwfD/Be3fFP0RgOnbhYSYVKq6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 706/849] signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)
Date:   Mon, 15 Nov 2021 18:03:09 +0100
Message-Id: <20211115165444.146868366@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit ce0ee4e6ac99606f3945f4d47775544edc3f7985 ]

Today the sh code allocates memory the first time a process uses
the fpu.  If that memory allocation fails, kill the affected task
with force_sig(SIGKILL) rather than do_group_exit(SIGKILL).

Calling do_group_exit from an exception handler can potentially lead
to dead locks as do_group_exit is not designed to be called from
interrupt context.  Instead use force_sig(SIGKILL) to kill the
userspace process.  Sending signals in general and force_sig in
particular has been tested from interrupt context so there should be
no problems.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Fixes: 0ea820cf9bf5 ("sh: Move over to dynamically allocated FPU context.")
Link: https://lkml.kernel.org/r/20211020174406.17889-6-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/kernel/cpu/fpu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/cpu/fpu.c b/arch/sh/kernel/cpu/fpu.c
index ae354a2931e7e..fd6db0ab19288 100644
--- a/arch/sh/kernel/cpu/fpu.c
+++ b/arch/sh/kernel/cpu/fpu.c
@@ -62,18 +62,20 @@ void fpu_state_restore(struct pt_regs *regs)
 	}
 
 	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
+		int ret;
 		/*
 		 * does a slab alloc which can sleep
 		 */
-		if (init_fpu(tsk)) {
+		local_irq_enable();
+		ret = init_fpu(tsk);
+		local_irq_disable();
+		if (ret) {
 			/*
 			 * ran out of memory!
 			 */
-			do_group_exit(SIGKILL);
+			force_sig(SIGKILL);
 			return;
 		}
-		local_irq_disable();
 	}
 
 	grab_fpu(regs);
-- 
2.33.0



