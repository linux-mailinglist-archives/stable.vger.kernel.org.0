Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5926E3F664A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbhHXRWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236970AbhHXRUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B90961AFB;
        Tue, 24 Aug 2021 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824596;
        bh=a01H8wLm6Zu59H6wvkNY1oCYyOmh6w5yAlyUoKjNJkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kU9h8JhwPk7wSHrKv/XDs5k0x0IoRmAf2zt3kp3gWhw24fwJdSi9XUgGCU4WAuFHY
         qWTFP/jMQW2UQiRa689pE8QmsLR+4Ajh5wuP51tw6uXULXIRvU8WlMCGYJdxwpLy+P
         Awp8bOL4EpEAaxQ3l/z3wMvknRLNhf556zm3YO1Vs2lyOQ3fX6+ILS+Gy1/jkzDJfY
         8Zz0h94/kURNvOut8jjMOMBqMS6E1jWAmzUkETGzgv8eIdbzt/lAgu9sfOXjnISl91
         CqjadO5pvCl1xN1cLttFVZVpzdbZex2cSD2zb955HjLjvlwKKXejQ9gEZ42wwujNgK
         z+M1E8u9cPDAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/84] x86/tools: Fix objdump version check again
Date:   Tue, 24 Aug 2021 13:01:51 -0400
Message-Id: <20210824170250.710392-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 839ad22f755132838f406751439363c07272ad87 ]

Skip (omit) any version string info that is parenthesized.

Warning: objdump version 15) is older than 2.19
Warning: Skipping posttest.

where 'objdump -v' says:
GNU objdump (GNU Binutils; SUSE Linux Enterprise 15) 2.35.1.20201123-7.18

Fixes: 8bee738bb1979 ("x86: Fix objdump version check in chkobjdump.awk for different formats.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210731000146.2720-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/tools/chkobjdump.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index fd1ab80be0de..a4cf678cf5c8 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -10,6 +10,7 @@ BEGIN {
 
 /^GNU objdump/ {
 	verstr = ""
+	gsub(/\(.*\)/, "");
 	for (i = 3; i <= NF; i++)
 		if (match($(i), "^[0-9]")) {
 			verstr = $(i);
-- 
2.30.2

