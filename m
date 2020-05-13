Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE811D0DEC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbgEMJzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388280AbgEMJze (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821D724939;
        Wed, 13 May 2020 09:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363734;
        bh=Utj4unmRqlPXrHEzY9x3fEDqoQcq55JvcGGoPofXDVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0JM+9UQkjOjPbLEq77qWtYUZQ4gzxIlNEKoDyrelLcqMLnuOk45Sf7Xvb00P13Jw
         6mqNNAiddrvwQM3pV5sHmN4eBsPmw0nTR2kZzg6sKJMYtiXsDVjvb1lQlCMu+bdE7K
         8lO4rugAV7X7aiaSBoyEvT6FFungk+9vIDPydNZY=
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
Subject: [PATCH 5.6 103/118] x86/unwind/orc: Fix error path for bad ORC entry type
Date:   Wed, 13 May 2020 11:45:22 +0200
Message-Id: <20200513094426.285709112@linuxfoundation.org>
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

commit a0f81bf26888048100bf017fadf438a5bdffa8d8 upstream.

If the ORC entry type is unknown, nothing else can be done other than
reporting an error.  Exit the function instead of breaking out of the
switch statement.

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
Link: https://lore.kernel.org/r/a7fa668ca6eabbe81ab18b2424f15adbbfdc810a.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/unwind_orc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -531,7 +531,7 @@ bool unwind_next_frame(struct unwind_sta
 	default:
 		orc_warn("unknown .orc_unwind entry type %d for ip %pB\n",
 			 orc->type, (void *)orig_ip);
-		break;
+		goto err;
 	}
 
 	/* Find BP: */


