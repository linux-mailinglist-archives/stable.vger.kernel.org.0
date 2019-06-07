Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4530F3905F
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfFGPv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731201AbfFGPui (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC0A20657;
        Fri,  7 Jun 2019 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922637;
        bh=foEfC+2i2Z0fHl3DRVDfDilQ1mKQWJcTNDW6T2A444U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irYVroFIR4URdMfu1lc+XYlzCrCUM5vY/RVaW++2Er0l60L182pvz3qTUIwPI8j2M
         NO/Ss78VuOIxjR7KucU4qBYpX1+WubV/U3yfZcPXTx54z6XcDtTsAy6XMMT3iavykF
         5U3Xqg9sRCfwCqmqEVESr2UWssUaEfVLWWgzgp1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alec Ari <neotheuser@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.1 84/85] Revert "x86/build: Move _etext to actual end of .text"
Date:   Fri,  7 Jun 2019 17:40:09 +0200
Message-Id: <20190607153858.097760804@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 392bef709659abea614abfe53cf228e7a59876a4.

It seems to cause lots of problems when using the gold linker, and no
one really needs this at the moment, so just revert it from the stable
trees.

Cc: Sami Tolvanen <samitolvanen@google.com>
Reported-by: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Alec Ari <neotheuser@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
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
 


