Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6D3325B3D
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 02:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhBZBXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 20:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhBZBX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC90864F49;
        Fri, 26 Feb 2021 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302552;
        bh=9D3MCTfUWcx8h6AOs9X1S6qRmekrACM7jyDIHxg84YY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ujsrM1VFch/lB8MicVYu4rRHFs/+bGmkxuHx2/xN3NCeFUCPjehlbs7jDO5B31L4a
         Y1Lk1v4Rgd+80FNBUDNtPGrXYDhOC8cUvxvbcB0x3iqsAhC8btHoMFZIBahL7dqET9
         uNhpZCG3pT/cOSdDXiGNImClbUpsW6VtLsbKm4ZQ=
Date:   Thu, 25 Feb 2021 17:22:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dave.hansen@linux.intel.com, davem@davemloft.net,
        linux-mm@kvack.org, lucien.xin@gmail.com, luto@kernel.org,
        marcelo.leitner@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, neilb@suse.de, nhorman@tuxdriver.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        vyasevich@gmail.com
Subject:  [patch 113/118] x86: fix seq_file iteration for
 pat/memtype.c
Message-ID: <20210226012229.S5QJUOJAz%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>
Subject: x86: fix seq_file iteration for pat/memtype.c

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
---

 arch/x86/mm/pat/memtype.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-fix-seq_file-iteration-for-pat-memtypec
+++ a/arch/x86/mm/pat/memtype.c
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
 
_
