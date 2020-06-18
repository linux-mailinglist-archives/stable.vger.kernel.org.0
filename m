Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334821FE1C5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbgFRB5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbgFRBZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF04221EE;
        Thu, 18 Jun 2020 01:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443512;
        bh=oz9WUU05V+vR5SeYhnmeKUgrS8zd6RKplIzjiqi8ZWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJ6rWp3p1PRgwzGkqne1aSSL7LHUbCYhLTVixi8/QrzXuRnBZ4wb538lZmn3aHAhd
         ButQ2+7g4EGSWk/K4KINcTfaoM/uXGEdLjj9F1LTzXmJ7zZbiGcQsE+ZuMsOv2Zlvt
         pcAvvbJS/26odpp56SsD19RmhfN6sWZBLr1l95gA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stafford Horne <shorne@gmail.com>, Sasha Levin <sashal@kernel.org>,
        openrisc@lists.librecores.org
Subject: [PATCH AUTOSEL 4.19 136/172] openrisc: Fix issue with argument clobbering for clone/fork
Date:   Wed, 17 Jun 2020 21:21:42 -0400
Message-Id: <20200618012218.607130-136-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
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
index ee6159d2ed22..01b59d2ce174 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1170,13 +1170,13 @@ ENTRY(__sys_clone)
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

