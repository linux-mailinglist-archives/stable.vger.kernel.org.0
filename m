Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322172A513D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgKCUil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbgKCUil (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4643822226;
        Tue,  3 Nov 2020 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435920;
        bh=1e+jJ2JMYtK1uaKazz4HqSjoXw+cWKvPgzN3SsMC/CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F++LPkcsam9Zl3z3Ciz9Zk5xUxPSK8yCF5ZYPTE0fgEPuYNKOLJ/alMN849pjRaZi
         lZs7DbOSK40KD1oGf07SqGf68IjqQnTHfgosYF2eiFxqQmJrJwvnDkHsx7vqYhXrTw
         f8+OYUk/iaBLm0Fv2AgvNBvN6s5HUjEH+sOOPnqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+53f8ce8bbc07924b6417@syzkaller.appspotmail.com,
        kernel test robot <lkp@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 040/391] lockdep: Fix preemption WARN for spurious IRQ-enable
Date:   Tue,  3 Nov 2020 21:31:31 +0100
Message-Id: <20201103203350.357256240@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f8e48a3dca060e80f672d398d181db1298fbc86c ]

It is valid (albeit uncommon) to call local_irq_enable() without first
having called local_irq_disable(). In this case we enter
lockdep_hardirqs_on*() with IRQs enabled and trip a preemption warning
for using __this_cpu_read().

Use this_cpu_read() instead to avoid the warning.

Fixes: 4d004099a6 ("lockdep: Fix lockdep recursion")
Reported-by: syzbot+53f8ce8bbc07924b6417@syzkaller.appspotmail.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 85d15f0362dc5..3eb35ad1b5241 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3681,7 +3681,7 @@ void lockdep_hardirqs_on_prepare(unsigned long ip)
 	if (unlikely(in_nmi()))
 		return;
 
-	if (unlikely(__this_cpu_read(lockdep_recursion)))
+	if (unlikely(this_cpu_read(lockdep_recursion)))
 		return;
 
 	if (unlikely(lockdep_hardirqs_enabled())) {
@@ -3750,7 +3750,7 @@ void noinstr lockdep_hardirqs_on(unsigned long ip)
 		goto skip_checks;
 	}
 
-	if (unlikely(__this_cpu_read(lockdep_recursion)))
+	if (unlikely(this_cpu_read(lockdep_recursion)))
 		return;
 
 	if (lockdep_hardirqs_enabled()) {
-- 
2.27.0



