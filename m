Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06D6355B
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 14:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfGIMEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 08:04:14 -0400
Received: from terminus.zytor.com ([198.137.202.136]:41425 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfGIMEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 08:04:14 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x69C3arr1902264
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 9 Jul 2019 05:03:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x69C3arr1902264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1562673817;
        bh=uURZ37HfIgMAvVVbO7RjyevVofVShrjM/dTDNFpp52g=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=dn6Irr6WMw8dBRn2unL2eS4nJN1J/IAYAUMi/p2WIKxmLuKUh0Us0Z0UtU6mFBLZX
         UPXlP/IKXHp2nD5KE9aIR0epeZH9ihi76Tjc5TZqyJHQUCim1GbEkJXr6BfuBn6bPb
         Mml03ooq6QAuZsnHsC1jiuVzFOqaM6i2OYuoBNJ+NV+Dzh2IllExQzPf/iSbBfWXgh
         PNHESpVagF4e/PZvWmxaam4qvaT9cPZHTm1bhlEoOaTFdp9KausS5c3Sss20RyAn4E
         QU1BbGeprX9/oHCC9N1n3/onw88hgWHYEVnl++oL49d12X7tmmtyumCv3/8tGsBCQJ
         MRfd+ggk9APMg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x69C3YGo1902260;
        Tue, 9 Jul 2019 05:03:34 -0700
Date:   Tue, 9 Jul 2019 05:03:34 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-013c66edf207ddb78422b8b636f56c87939c9e34@git.kernel.org>
Cc:     zwisler@google.com, zwisler@chromium.org,
        johannes.hirte@datenkhaos.de, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, groeck@google.com, stable@vger.kernel.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, klaus.kusche@computerix.info,
        groeck@chromium.org
Reply-To: linux-kernel@vger.kernel.org, keescook@chromium.org,
          groeck@google.com, stable@vger.kernel.org, mingo@kernel.org,
          groeck@chromium.org, klaus.kusche@computerix.info,
          zwisler@google.com, tglx@linutronix.de,
          johannes.hirte@datenkhaos.de, zwisler@chromium.org, bp@alien8.de,
          hpa@zytor.com
In-Reply-To: <20190701155208.211815-1-zwisler@google.com>
References: <20190701155208.211815-1-zwisler@google.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86/build: Move _etext to actual end of
 .text"
Git-Commit-ID: 013c66edf207ddb78422b8b636f56c87939c9e34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  013c66edf207ddb78422b8b636f56c87939c9e34
Gitweb:     https://git.kernel.org/tip/013c66edf207ddb78422b8b636f56c87939c9e34
Author:     Ross Zwisler <zwisler@chromium.org>
AuthorDate: Mon, 1 Jul 2019 09:52:08 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Jul 2019 13:57:31 +0200

Revert "x86/build: Move _etext to actual end of .text"

This reverts commit 392bef709659abea614abfe53cf228e7a59876a4.

Per the discussion here:

  https://lkml.kernel.org/r/201906201042.3BF5CD6@keescook

the above referenced commit breaks kernel compilation with old GCC
toolchains as well as current versions of the Gold linker.

Revert it to fix the regression and to keep the ability to compile the
kernel with these tools.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: <stable@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Johannes Hirte <johannes.hirte@datenkhaos.de>
Cc: Klaus Kusche <klaus.kusche@computerix.info>
Cc: samitolvanen@google.com
Cc: Guenter Roeck <groeck@google.com>
Link: https://lkml.kernel.org/r/20190701155208.211815-1-zwisler@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vmlinux.lds.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0850b5149345..4d1517022a14 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -141,10 +141,10 @@ SECTIONS
 		*(.text.__x86.indirect_thunk)
 		__indirect_thunk_end = .;
 #endif
-	} :text = 0x9090
 
-	/* End of text section */
-	_etext = .;
+		/* End of text section */
+		_etext = .;
+	} :text = 0x9090
 
 	NOTES :text :note
 
