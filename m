Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA61D0DFC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbgEMJ5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgEMJzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40624206D6;
        Wed, 13 May 2020 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363731;
        bh=wNqhK09+vy5pAjg9udqz0wedimf4x5mmtaDPwcfEfaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYGzi5JYToeP63ueTUqfWgzeogzv/S0soBwts43tm9Qv6IdPXwH/p66OBrYILmF+b
         FnaeMLbYLC5AC6iPEzuCWPCm6FmKd/fp/QQ9d6oDEFZFFr1dbA4cdCWvWFSmDvax4s
         PdrQAHxdeaokl8UJyNoXePrrLIcnkUUOP+gWuB5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 5.6 102/118] x86/unwind/orc: Prevent unwinding before ORC initialization
Date:   Wed, 13 May 2020 11:45:21 +0200
Message-Id: <20200513094426.200475428@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 98d0c8ebf77e0ba7c54a9ae05ea588f0e9e3f46e upstream.

If the unwinder is called before the ORC data has been initialized,
orc_find() returns NULL, and it tries to fall back to using frame
pointers.  This can cause some unexpected warnings during boot.

Move the 'orc_init' check from orc_find() to __unwind_init(), so that it
doesn't even try to unwind from an uninitialized state.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/069d1499ad606d85532eb32ce39b2441679667d5.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/unwind_orc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -142,9 +142,6 @@ static struct orc_entry *orc_find(unsign
 {
 	static struct orc_entry *orc;
 
-	if (!orc_init)
-		return NULL;
-
 	if (ip == 0)
 		return &null_orc_entry;
 
@@ -585,6 +582,9 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long *first_frame)
 {
+	if (!orc_init)
+		goto done;
+
 	memset(state, 0, sizeof(*state));
 	state->task = task;
 


