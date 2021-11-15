Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8654522B6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbhKPBPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244338AbhKOTNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5FC634B1;
        Mon, 15 Nov 2021 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000414;
        bh=0N2XChuYHDIg6RzfUEHvxBwuYTZ1e/N0ZX+4R4kwOtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yT1SniY2u36Ze2JEkcr39XE2AortST8oFIlIKKLCPvWkO1spwj+muVTIR+DqXogtn
         dAP/0/ODlDiAgsqfVPhWvD8487HzWG3zaoswpeD8L9KGPhDviloD8KIq/wZH+vffZE
         8SVQw0t6I+lKivjbL6O2TcmYFYgwCepa+k0iyn5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 652/849] powerpc/xmon: fix task state output
Date:   Mon, 15 Nov 2021 18:02:15 +0100
Message-Id: <20211115165442.323611134@linuxfoundation.org>
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

From: Denis Kirjanov <kda@linux-powerpc.org>

[ Upstream commit b1f896ce3542eb2eede5949ee2e481526fae1108 ]

p_state is unsigned since the commit 2f064a59a11f

The patch also uses TASK_RUNNING instead of null.

Fixes: 2f064a59a11f ("sched: Change task_struct::state")
Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211026133108.7113-1-kda@linux-powerpc.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index da4d7f225a409..47518116e9533 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3274,8 +3274,7 @@ static void show_task(struct task_struct *volatile tsk)
 	 * appropriate for calling from xmon. This could be moved
 	 * to a common, generic, routine used by both.
 	 */
-	state = (p_state == 0) ? 'R' :
-		(p_state < 0) ? 'U' :
+	state = (p_state == TASK_RUNNING) ? 'R' :
 		(p_state & TASK_UNINTERRUPTIBLE) ? 'D' :
 		(p_state & TASK_STOPPED) ? 'T' :
 		(p_state & TASK_TRACED) ? 'C' :
-- 
2.33.0



