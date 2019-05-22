Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A185F26CE5
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbfEVT35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733100AbfEVT35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:29:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91EE2204FD;
        Wed, 22 May 2019 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553396;
        bh=Zj+sm+pNxIxJQRe+phzG84j9QSjnWB7G9pMS0mrd9Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJbY31OgjmD2puin/KXst6yv6l93bi0H2/8tpyLCC/3572hFuQ4fOSo3zYGYCzPL0
         nDcDazdyUkQmVo5Z8iAwHxt9pI/n3Ev7d0UkFo8TCM/2iRr1iwlnE+TlSuN6geE4Xi
         yzFgsTf/KqiN3/7I0bdUoLWr5Ztcevd1P5ny79O0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 050/167] x86/build: Move _etext to actual end of .text
Date:   Wed, 22 May 2019 15:26:45 -0400
Message-Id: <20190522192842.25858-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 392bef709659abea614abfe53cf228e7a59876a4 ]

When building x86 with Clang LTO and CFI, CFI jump regions are
automatically added to the end of the .text section late in linking. As a
result, the _etext position was being labelled before the appended jump
regions, causing confusion about where the boundaries of the executable
region actually are in the running kernel, and broke at least the fault
injection code. This moves the _etext mark to outside (and immediately
after) the .text area, as it already the case on other architectures
(e.g. arm64, arm).

Reported-and-tested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20190423183827.GA4012@beast
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/vmlinux.lds.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2384a2ae5ec3e..23df6eebe82f4 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -131,11 +131,11 @@ SECTIONS
 		*(.text.__x86.indirect_thunk)
 		__indirect_thunk_end = .;
 #endif
-
-		/* End of text section */
-		_etext = .;
 	} :text = 0x9090
 
+	/* End of text section */
+	_etext = .;
+
 	NOTES :text :note
 
 	EXCEPTION_TABLE(16) :text = 0x9090
-- 
2.20.1

