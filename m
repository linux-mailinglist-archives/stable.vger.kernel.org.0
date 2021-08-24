Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76A73F6700
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbhHXRaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240446AbhHXR2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22A661B5E;
        Tue, 24 Aug 2021 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824717;
        bh=a01H8wLm6Zu59H6wvkNY1oCYyOmh6w5yAlyUoKjNJkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEtMo793fHc0Pf9uuSQSgK5mhV47zwPvoH1dCYHUIMiLmgYy3qs12n88SwWmPzpK8
         Ko8YuwZEN/zXIRmPZj67ewlREf6WLwep4doljovMp3JYJPzNpz3ykoCGd7vp/7Jpsk
         Er/3dp/HjdNObrdq06Pzki0K+b2I48tBL25s/TYMopN5FC/2M3jbBlK2XuRiviEKI9
         A8DAHFoQi1wehlFI/OsEaVdlpdG6EDm8TQA8QXadgmOjODHwccZlqJ+6sdUmiZLNFO
         pm+JZUJpcPpSJYvIGPZyD/QCO64zm1zKLTc3jUp+/3sRJHBQBTk2o2fdj/Wd1MGiFH
         c3hojoJSbyz8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/64] x86/tools: Fix objdump version check again
Date:   Tue, 24 Aug 2021 13:04:12 -0400
Message-Id: <20210824170457.710623-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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

