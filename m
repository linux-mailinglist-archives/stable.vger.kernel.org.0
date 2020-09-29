Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B50E27CA82
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgI2Lf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbgI2LfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8618C23D20;
        Tue, 29 Sep 2020 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378954;
        bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sc+JawjX6kEzRYEYXYhH09HTjTTAWR4IFha6mP15M2C6AQUs96EOOtPWe2ARvDDmp
         THJzCuBhou+Lo+FAZDRtTA4Nyl+SsvEkNuXz2e+IEVPHB3KCsCZF0aNR7egoBmGN/l
         7kx3IwXHb2Pzk+ZG7OHAfzFrDhfIZgzeoG3KIN/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/245] selftests/x86/syscall_nt: Clear weird flags after each test
Date:   Tue, 29 Sep 2020 13:00:50 +0200
Message-Id: <20200929105956.658123534@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



