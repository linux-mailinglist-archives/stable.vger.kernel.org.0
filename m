Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F91FDBCC
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgFRBOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgFRBOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0009B2193E;
        Thu, 18 Jun 2020 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442890;
        bh=gcYIdJSBndXo8ib41qkOp7IDNKCp6T94n1aw+8dxIIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHRfdvLqjyZsW6g99eM1+psSgkitdeKAGnxLTD8c6VwttLrH4Wy5Y9NyD+V0zNWaG
         unnA3eH0b9PIQ56xZZrlLzNzVqIbOJrU2Wf4VyESzbpJU7DLkZwWAke5MMjaNtfOuh
         l0KuCXWKWnMw+YSp3XHG+JniHPEL40vZDv1NYUH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Sasha Levin <sashal@kernel.org>,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 5.7 313/388] openrisc: Fix issue with argument clobbering for clone/fork
Date:   Wed, 17 Jun 2020 21:06:50 -0400
Message-Id: <20200618010805.600873-313-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 6bd140e14d9aaa734ec37985b8b20a96c0ece948 ]

Working on the OpenRISC glibc port I found that sometimes clone was
working strange.  That the tls data argument sent in r7 was always
wrong.  Further investigation revealed that the arguments were getting
clobbered in the entry code.  This patch removes the code that writes to
the argument registers.  This was likely due to some old code hanging
around.

This patch fixes this up for clone and fork.  This fork clobber is
harmless but also useless so remove.

Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index e4a78571f883..c6481cfc5220 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1166,13 +1166,13 @@ ENTRY(__sys_clone)
 	l.movhi	r29,hi(sys_clone)
 	l.ori	r29,r29,lo(sys_clone)
 	l.j	_fork_save_extra_regs_and_call
-	 l.addi	r7,r1,0
+	 l.nop
 
 ENTRY(__sys_fork)
 	l.movhi	r29,hi(sys_fork)
 	l.ori	r29,r29,lo(sys_fork)
 	l.j	_fork_save_extra_regs_and_call
-	 l.addi	r3,r1,0
+	 l.nop
 
 ENTRY(sys_rt_sigreturn)
 	l.jal	_sys_rt_sigreturn
-- 
2.25.1

