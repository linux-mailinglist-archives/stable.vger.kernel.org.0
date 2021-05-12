Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A546337C8EA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbhELQNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239351AbhELQHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8178C61D27;
        Wed, 12 May 2021 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833856;
        bh=33WmF46uUq8RhxwI563b1dAicHlzASiL+mKzXpIOTtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deEC7JUvOd7LYQxfFEqb6egEocJr+Vx13dNv1AkWK5ULT7rVTIllU7NV+PigdE+rI
         qUMf4wibBM2eDAywwx6uOaZlHuy6r7qEhqlev7onK4mD2ASJDBAHHOiQYRnvAijMoM
         F/7C4ErT4KvGHwlkUnX/4xJMhS+uULiakzCTF+NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 315/601] rcu: Remove spurious instrumentation_end() in rcu_nmi_enter()
Date:   Wed, 12 May 2021 16:46:32 +0200
Message-Id: <20210512144838.192318519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

[ Upstream commit 6494ccb93271bee596a12db32ff44867d5be2321 ]

In rcu_nmi_enter(), there is an erroneous instrumentation_end() in the
second branch of the "if" statement.  Oddly enough, "objtool check -f
vmlinux.o" fails to complain because it is unable to correctly cover
all cases.  Instead, objtool visits the third branch first, which marks
following trace_rcu_dyntick() as visited.  This commit therefore removes
the spurious instrumentation_end().

Fixes: 04b25a495bd6 ("rcu: Mark rcu_nmi_enter() call to rcu_cleanup_after_idle() noinstr")
Reported-by Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 84a3fe09630b..e7d8a0d8ea7c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1072,7 +1072,6 @@ noinstr void rcu_nmi_enter(void)
 	} else if (!in_nmi()) {
 		instrumentation_begin();
 		rcu_irq_enter_check_tick();
-		instrumentation_end();
 	} else  {
 		instrumentation_begin();
 	}
-- 
2.30.2



