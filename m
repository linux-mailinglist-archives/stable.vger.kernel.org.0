Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C073291D6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242487AbhCAUdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243172AbhCAU04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4983A65415;
        Mon,  1 Mar 2021 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622025;
        bh=u4SG6M3G1nmPeiSzVDW4d6z5jO1jgWECCeUY3HyZscE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaQpyG/Qx3hsUf+k8U/WKB1Jz7puO+HUu3GzmHKJo+hyZdJSGZk6OWRLKOP5ufhyw
         gzXWqNiCRL0mkmjsKmDvJvMhzpb84s2CQujA6itLr9ISXN0eo8tV9HjmmO7k96IX37
         v3Oxr07ljPk73nT7gaZd53QIwx7p8hLeLpwOMsO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Xin Long <lucien.xin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 699/775] seq_file: document how per-entry resources are managed.
Date:   Mon,  1 Mar 2021 17:14:27 +0100
Message-Id: <20210301161235.911699240@linuxfoundation.org>
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

commit b3656d8227f4c45812c6b40815d8f4e446ed372a upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/seq_file.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/filesystems/seq_file.rst
+++ b/Documentation/filesystems/seq_file.rst
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


