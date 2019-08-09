Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5082487C00
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436501AbfHINqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407091AbfHINqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80EC421783;
        Fri,  9 Aug 2019 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358392;
        bh=H0sWFOueeeS1zUluRBeeGFPxXiJh4BA+1FDm/ukyBBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkGBAbqd9XC5e45MmekSYAgyIc1aexX184YGcLfGvK4vYs0rdIqW/We2coACJYx9k
         D2BPrMLqSjIrh8nHRJzjgriSV21ZLLgXZEVHPmUWSnoWvYTz4o5EJBcSrrM0UXIC+f
         3EUeSGQV405JdqJ4vCr2yeq6z+sgwqSDUmrsSczs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 20/21] x86/entry/64: Use JMP instead of JMPQ
Date:   Fri,  9 Aug 2019 15:45:24 +0200
Message-Id: <20190809134242.383550628@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 64dbc122b20f75183d8822618c24f85144a5a94d upstream.

Somehow the swapgs mitigation entry code patch ended up with a JMPQ
instruction instead of JMP, where only the short jump is needed.  Some
assembler versions apparently fail to optimize JMPQ into a two-byte JMP
when possible, instead always using a 7-byte JMP with relocation.  For
some reason that makes the entry code explode with a #GP during boot.

Change it back to "JMP" as originally intended.

Fixes: 18ec54fdd6d1 ("x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations")
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -567,7 +567,7 @@ END(irq_entries_start)
 #ifdef CONFIG_CONTEXT_TRACKING
 	call enter_from_user_mode
 #endif
-	jmpq	2f
+	jmp	2f
 1:
 	FENCE_SWAPGS_KERNEL_ENTRY
 2:


