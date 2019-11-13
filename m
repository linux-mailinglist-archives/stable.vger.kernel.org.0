Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB584FA569
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKMBwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbfKMBww (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015C82245C;
        Wed, 13 Nov 2019 01:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609971;
        bh=XXWeIEQ8U9uvT64M1yYZKHYf6SWtclJtjjaKjs4BSYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzoZVBQz0jIF235EXezjRckAi8o/B5l6jKJxE9bMbSkd45PjkJtnLcRtf7+wA7fJ5
         QtNw3BhCM0HR7Hmhu25QBHOjVLr+DRBEhvYUXsX+AAL0wcs/WJCKAsq0AmDkTWWTrz
         bfSOfONQxLjGaiB4avVvSRqZO7ppP2ULi34m27c4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 099/209] cpu/SMT: State SMT is disabled even with nosmt and without "=force"
Date:   Tue, 12 Nov 2019 20:48:35 -0500
Message-Id: <20191113015025.9685-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit d0e7d14455d41163126afecd0fcce935463cc512 ]

When booting with "nosmt=force" a message is issued into dmesg to
confirm that SMT has been force-disabled but such a message is not
issued when only "nosmt" is on the kernel command line.

Fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20181004172227.10094-1-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d9f855cb9f6f9..17279d87524ce 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -375,6 +375,7 @@ void __init cpu_smt_disable(bool force)
 		pr_info("SMT: Force disabled\n");
 		cpu_smt_control = CPU_SMT_FORCE_DISABLED;
 	} else {
+		pr_info("SMT: disabled\n");
 		cpu_smt_control = CPU_SMT_DISABLED;
 	}
 }
-- 
2.20.1

