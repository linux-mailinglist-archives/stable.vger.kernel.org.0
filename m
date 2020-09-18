Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7626EFDF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgIRCjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbgIRCMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1319208E4;
        Fri, 18 Sep 2020 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395130;
        bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVz1Iq8H7TP2zQe4IVm6ZK7yfjeGfTnvQ1T2ycaDJWqwAtwakEvtIPCwITdLNgp4V
         sbKcDbIdLQfJacR2rRtgANAH9DERXgJ9mhilC2tO8//cOoJ6KSh+dVSWtUw3t3lYL2
         UPbjtccjyLn5oZSY0WRsqgRSAHiW9AZ+oPdl+Afc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 200/206] selftests/x86/syscall_nt: Clear weird flags after each test
Date:   Thu, 17 Sep 2020 22:07:56 -0400
Message-Id: <20200918020802.2065198-200-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit a61fa2799ef9bf6c4f54cf7295036577cececc72 ]

Clear the weird flags before logging to improve strace output --
logging results while, say, TF is set does no one any favors.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/907bfa5a42d4475b8245e18b67a04b13ca51ffdb.1593191971.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/syscall_nt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/x86/syscall_nt.c b/tools/testing/selftests/x86/syscall_nt.c
index 43fcab367fb0a..74e6b3fc2d09e 100644
--- a/tools/testing/selftests/x86/syscall_nt.c
+++ b/tools/testing/selftests/x86/syscall_nt.c
@@ -67,6 +67,7 @@ static void do_it(unsigned long extraflags)
 	set_eflags(get_eflags() | extraflags);
 	syscall(SYS_getpid);
 	flags = get_eflags();
+	set_eflags(X86_EFLAGS_IF | X86_EFLAGS_FIXED);
 	if ((flags & extraflags) == extraflags) {
 		printf("[OK]\tThe syscall worked and flags are still set\n");
 	} else {
-- 
2.25.1

