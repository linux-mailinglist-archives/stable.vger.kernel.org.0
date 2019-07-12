Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA266DEF
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfGLMfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfGLMfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:35:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AEA9216B7;
        Fri, 12 Jul 2019 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934900;
        bh=TyjZHA5J/rjfmvLhvSpZtxGosN4QLpv8RgvSBHoXeK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoUK+qp+Thxv/rn0U4SUZSkmO9g7qT9uGQGRViZZXSCsorjfdjJYNG3dcjtQZ8tDx
         xuL8SlzZS/4V9K/UE31YvCv4VKyv2FzI67IdM10MuRjuoailGRauHJd3yJZu2j59qY
         gBcIXWySFusRkb9uun/EeYfY1cy1XkuTrQmWGmjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Johannes Hirte <johannes.hirte@datenkhaos.de>,
        Klaus Kusche <klaus.kusche@computerix.info>,
        samitolvanen@google.com, Guenter Roeck <groeck@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.2 51/61] Revert "x86/build: Move _etext to actual end of .text"
Date:   Fri, 12 Jul 2019 14:20:04 +0200
Message-Id: <20190712121623.439584746@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Zwisler <zwisler@chromium.org>

commit 013c66edf207ddb78422b8b636f56c87939c9e34 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/vmlinux.lds.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 


