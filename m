Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8525463770
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbhK3Oxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46530 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242607AbhK3Owm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60313B81A29;
        Tue, 30 Nov 2021 14:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC5C53FC7;
        Tue, 30 Nov 2021 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283761;
        bh=WHvIF6roDxkp51LoITwali+JqdjuBIAh4l8eeRWGo1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqYarOeOcsaZEm2NgVrVQVwZegNqfRJ8qfmTcw7JQxUDA7DtjT3oQ0zJPxk2gIq15
         gMQ/v76/yiOKVqaGcOPt/KxJJYu4be63yi9L/ROhpSWf74D0p7C5oTjDF9QG0vttE6
         6DibP+c/KWbKUwEs5BKcFd+yPQhVjp8mKbwCnznjmrGm2rF+Bi4j/fu9aj8oNVikTE
         kwwK9KPI0eLlsV85SOs8Fk6chZQ/Ve+so1SNsT8/l0XAhcoNSM9/UdJm5hBSsAgMQB
         a5S3JwYfd63KhYJLezdtiqcxSGELhblfpKCUJboVUuxBxhNZ0hYjfCKSqVf/x7L+Du
         l0dVE0zrVDiCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, rppt@kernel.org, akpm@linux-foundation.org,
        rafael.j.wysocki@intel.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, jgross@suse.com,
        mlombard@redhat.com
Subject: [PATCH AUTOSEL 5.15 53/68] x86/boot: Mark prepare_command_line() __init
Date:   Tue, 30 Nov 2021 09:46:49 -0500
Message-Id: <20211130144707.944580-53-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit c0f2077baa4113f38f008b8e912b9fb3ff8d43df ]

Fix:

  WARNING: modpost: vmlinux.o(.text.unlikely+0x64d0): Section mismatch in reference \
   from the function prepare_command_line() to the variable .init.data:command_line
  The function prepare_command_line() references
  the variable __initdata command_line.
  This is often because prepare_command_line lacks a __initdata
  annotation or the annotation of command_line is wrong.

Apparently some toolchains do different inlining decisions.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YZySgpmBcNNM2qca@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d71267081153f..ee055430a89f4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,7 +742,7 @@ dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
 	return 0;
 }
 
-static char *prepare_command_line(void)
+static char * __init prepare_command_line(void)
 {
 #ifdef CONFIG_CMDLINE_BOOL
 #ifdef CONFIG_CMDLINE_OVERRIDE
-- 
2.33.0

