Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054753287B6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbhCAR2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhCARSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1556F65056;
        Mon,  1 Mar 2021 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617250;
        bh=STPFzSHHWTJjMcsWb2LqTYBn4U3MXowVAnweTf/CMvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4UqD4tBgaeqgsT92+INt3fZNv27OoU6JJT+so4Lq8xVut3yajfGN5WkNhwZn08Q0
         +12Os2wpbk0Z4gIhh1WwPfS+2N5KEm4l7DLUXlocxPcBlw/6W0Z09Hs7qRMpiVFvak
         5uUaRSWFmBZ7Ok7pEMKcLQpkjaghS5k01/YdEVnk=
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
Subject: [PATCH 4.19 220/247] x86: fix seq_file iteration for pat/memtype.c
Date:   Mon,  1 Mar 2021 17:14:00 +0100
Message-Id: <20210301161042.449644211@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
 arch/x86/mm/pat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -1131,12 +1131,14 @@ static void *memtype_seq_start(struct se
 
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
@@ -1145,7 +1147,6 @@ static int memtype_seq_show(struct seq_f
 
 	seq_printf(seq, "%s @ 0x%Lx-0x%Lx\n", cattr_name(print_entry->type),
 			print_entry->start, print_entry->end);
-	kfree(print_entry);
 
 	return 0;
 }


