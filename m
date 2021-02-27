Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D7326B26
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 03:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhB0Cdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 21:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhB0Cde (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3C564F37;
        Sat, 27 Feb 2021 02:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393164;
        bh=djyQ1uwgBaYYpyDMHCoOvJgB99UvOEqnbgmsNKTyYWo=;
        h=Date:From:To:Subject:From;
        b=LBDPCWMjsWlWNEoOp0+86KJckwomgSY4X2/3Fxmb6T9W3WwuFPF8bD85qxFNbbifJ
         DFvsSnwsoA8JOC8GC6b7QJt5Hpy/TEY0MjmVUwcCl2wsWruGVC4lR4Tt12WdSXPfZY
         xy7378iJBdl1jSx7Ulw+7TcJ+qCO8JcLp+OkHuWg=
Date:   Fri, 26 Feb 2021 18:32:43 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
        lucien.xin@gmail.com, luto@kernel.org, marcelo.leitner@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.de,
        nhorman@tuxdriver.com, peterz@infradead.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        vyasevich@gmail.com
Subject:  [merged]
 seq_file-document-how-per-entry-resources-are-managed.patch removed from
 -mm tree
Message-ID: <20210227023243.jxbUwwdO7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: seq_file: document how per-entry resources are managed.
has been removed from the -mm tree.  Its filename was
     seq_file-document-how-per-entry-resources-are-managed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: seq_file: document how per-entry resources are managed.

Patch series "Fix some seq_file users that were recently broken".

A recent change to seq_file broke some users which were using seq_file
in a non-"standard" way ...  though the "standard" isn't documented, so
they can be excused.  The result is a possible leak - of memory in one
case, of references to a 'transport' in the other.

These three patches:
 1/ document and explain the problem
 2/ fix the problem user in x86
 3/ fix the problem user in net/sctp


This patch (of 3):

Users of seq_file will sometimes find it convenient to take a resource,
such as a lock or memory allocation, in the ->start or ->next operations. 
These are per-entry resources, distinct from per-session resources which
are taken in ->start and released in ->stop.

The preferred management of these is release the resource on the
subsequent call to ->next or ->stop.

However prior to Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file
iteration code and interface") it happened that ->show would always be
called after ->start or ->next, and a few users chose to release the
resource in ->show.

This is no longer reliable.  Since the mentioned commit, ->next will
always come after a successful ->show (to ensure m->index is updated
correctly), so the original ordering cannot be maintained.

This patch updates the documentation to clearly state the required
behaviour.  Other patches will fix the few problematic users.

[akpm@linux-foundation.org: fix typo, per Willy]
Link: https://lkml.kernel.org/r/161248518659.21478.2484341937387294998.stgit@noble1
Link: https://lkml.kernel.org/r/161248539020.21478.3147971477400875336.stgit@noble1
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/filesystems/seq_file.rst~seq_file-document-how-per-entry-resources-are-managed
+++ a/Documentation/filesystems/seq_file.rst
@@ -217,6 +217,12 @@ between the calls to start() and stop(),
 is a reasonable thing to do. The seq_file code will also avoid taking any
 other locks while the iterator is active.
 
+The iterater value returned by start() or next() is guaranteed to be
+passed to a subsequent next() or stop() call.  This allows resources
+such as locks that were taken to be reliably released.  There is *no*
+guarantee that the iterator will be passed to show(), though in practice
+it often will be.
+
 
 Formatted output
 ================
_

Patches currently in -mm which might be from neilb@suse.de are


