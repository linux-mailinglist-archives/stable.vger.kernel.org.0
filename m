Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491922F62E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfE3Exw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfE3DKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDA5244A6;
        Thu, 30 May 2019 03:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185832;
        bh=qFjSTPMsUfvOtkrZNNJ0uzF/K6TRrBXGfznrF7cuUdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFEsAEtNTMraKKbgN49DiJ/yVa3Dzo+14qpGi4R+2ZeAgbsCxGhZskrCC79XohEqX
         1D0tFfE3Jz+65EQ+FrDwJKqBdtuUqWbMGOGCpAPqp8hdpwfn5PUSQzrpI78Jdv1y/w
         7A3zyDBF8qAYalNBF71CXUHnw+t6c2XBtyuBUu9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 5.1 137/405] x86/build: Move _etext to actual end of .text
Date:   Wed, 29 May 2019 20:02:15 -0700
Message-Id: <20190530030548.030497482@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a5127b2c195f9..834659288ba9b 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -141,11 +141,11 @@ SECTIONS
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



