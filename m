Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B9C3C8FB6
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbhGNTxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240374AbhGNTto (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5CC6143F;
        Wed, 14 Jul 2021 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291909;
        bh=D9e8Y4J/7pUkndTCimmJILrmK4V573fBUDB3wSvbpJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bw94Zakt0GmCpJBa/Nl51oCiXsFPgEv4bfYsgEXX4Vhsb3yhUDAvnsY7Q89vsn4ZC
         AvA/9IJtYRkuy0HR//RTz77/kdD7hFZWyCRsSA6UU5ymwSFFa7/cVY0PftjQG/7qUi
         SWIA1X58u3uw2qrWROTqmZiWSuTfrNZWfRqsTl3ZZpaFG6FO/eqqexkQ1YeZPl7rA2
         BQdLZ/xSxC4R1ZPsWm+eyaq7Njimap7xzyPf7UxzFTUMjflfEv9QqfyNts38VymSh2
         8gh08dAasLoWaa3dfUXcR0qsNmFQuP3wHm4aswUMP2clME9/h8W6t7h6Yst9O9BJfb
         6i3CaBBeRkozw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 86/88] s390/traps: do not test MONITOR CALL without CONFIG_BUG
Date:   Wed, 14 Jul 2021 15:43:01 -0400
Message-Id: <20210714194303.54028-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit b8e9cc20b808e26329090c19ff80b7f5098e98ff ]

tinyconfig fails to boot, because without CONFIG_BUG report_bug()
always returns BUG_TRAP_TYPE_BUG, which causes mc 0,0 in
test_monitor_call() to panic. Fix by skipping the test without
CONFIG_BUG.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 8d1e8a1a97df..16934fa19069 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -272,6 +272,8 @@ static void __init test_monitor_call(void)
 {
 	int val = 1;
 
+	if (!IS_ENABLED(CONFIG_BUG))
+		return;
 	asm volatile(
 		"	mc	0,0\n"
 		"0:	xgr	%0,%0\n"
-- 
2.30.2

