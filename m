Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872A4329118
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243232AbhCAUTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238611AbhCAUMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:12:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2351D653C6;
        Mon,  1 Mar 2021 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621655;
        bh=0W6Tg8ECAT1PTxpkPEM58FE0boZ8NCm6F1r1/jTuM/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqxTKeBhZAH9E5/BZfnluAmq015muhpueY2wwmU0ztvRbKoRbjnHvTXMhcfEQPpQE
         XjJBARmwaINFv7RlufpYTLjNhBakGIgEExKjyNwtWtkJ5cU7h6eRMMTxeDYxR1dSA9
         OCT9NeUo9XsXris2F7oO88qWXQ+RT2zCtvkS1aAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 565/775] csky: Fix a size determination in gpr_get()
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161229.392278083@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 8bfb676492da208bd6dde0f22dff79840dbb5051 ]

"*" is missed  in size determination as we are passing register set
rather than a pointer.

Fixes: dcad7854fcce ("sky: switch to ->regset_get()")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/csky/kernel/ptrace.c b/arch/csky/kernel/ptrace.c
index d822144906ac1..a4cf2e2ac15ac 100644
--- a/arch/csky/kernel/ptrace.c
+++ b/arch/csky/kernel/ptrace.c
@@ -83,7 +83,7 @@ static int gpr_get(struct task_struct *target,
 	/* Abiv1 regs->tls is fake and we need sync here. */
 	regs->tls = task_thread_info(target)->tp_value;
 
-	return membuf_write(&to, regs, sizeof(regs));
+	return membuf_write(&to, regs, sizeof(*regs));
 }
 
 static int gpr_set(struct task_struct *target,
-- 
2.27.0



