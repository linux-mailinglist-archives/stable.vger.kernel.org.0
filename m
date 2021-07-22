Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2C53D29F1
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGVQHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhGVQGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F1F61D61;
        Thu, 22 Jul 2021 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972396;
        bh=I8MWdxlpoilUiaepOxNxmoIT1ZEjDxBOyK7pqD1/Bqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu2GqoZWXmZyg2mfjG1saP1VnE/O/sXXQN/eCIhA8BQ0hECu7oHYsOhfONIgP1o+u
         CaMWSiNRY/fJ7x4PNwfc4N4y/YtbWBa3voEeOg2ApWwa5CES74Fzc1o1eoFrcrQw6n
         94ucD69ns7KcA2Xm7yqBQcCpGlaC3qoI0W/Cqu3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 098/156] s390/traps: do not test MONITOR CALL without CONFIG_BUG
Date:   Thu, 22 Jul 2021 18:31:13 +0200
Message-Id: <20210722155631.548022446@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8dd23c703718..662f52eb7639 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -277,6 +277,8 @@ static void __init test_monitor_call(void)
 {
 	int val = 1;
 
+	if (!IS_ENABLED(CONFIG_BUG))
+		return;
 	asm volatile(
 		"	mc	0,0\n"
 		"0:	xgr	%0,%0\n"
-- 
2.30.2



