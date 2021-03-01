Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A383291D7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhCAUeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243188AbhCAU07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FAB65417;
        Mon,  1 Mar 2021 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622027;
        bh=HQWsocddKk1rTCs1lKREmOb4su48pda2Hq3NdtSRDGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+JIxZqY9kqoLOgpo4mUntxfMwO63cXuFrH96Nvvg5mcWt1A4koOOJTGcxYXPeSVq
         ZBDyKKADEhUWtR8HJaZ4it3D/gLVSQLo06c6WCvt8nBpZML7ysgNB3sTvHKZqWMMfn
         idpeNz0OQudyChrIEqgMTVv7ET667k4BTElEB9Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Xin Long <lucien.xin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 700/775] x86: fix seq_file iteration for pat/memtype.c
Date:   Mon,  1 Mar 2021 17:14:28 +0100
Message-Id: <20210301161235.962036681@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit 3d2fc4c082448e9c05792f9b2a11c1d5db408b85 upstream.

The memtype seq_file iterator allocates a buffer in the ->start and ->next
functions and frees it in the ->show function.  The preferred handling for
such resources is to free them in the subsequent ->next or ->stop function
call.

Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
code and interface") there is no guarantee that ->show will be called
after ->next, so this function can now leak memory.

So move the freeing of the buffer to ->next and ->stop.

Link: https://lkml.kernel.org/r/161248539022.21478.13874455485854739066.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -1164,12 +1164,14 @@ static void *memtype_seq_start(struct se
 
 static void *memtype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	kfree(v);
 	++*pos;
 	return memtype_get_idx(*pos);
 }
 
 static void memtype_seq_stop(struct seq_file *seq, void *v)
 {
+	kfree(v);
 }
 
 static int memtype_seq_show(struct seq_file *seq, void *v)
@@ -1181,8 +1183,6 @@ static int memtype_seq_show(struct seq_f
 			entry_print->end,
 			cattr_name(entry_print->type));
 
-	kfree(entry_print);
-
 	return 0;
 }
 


