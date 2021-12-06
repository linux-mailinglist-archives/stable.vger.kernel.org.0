Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB87469C5C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356231AbhLFPV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358684AbhLFPTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A3CC0698D1;
        Mon,  6 Dec 2021 07:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4CC2612DB;
        Mon,  6 Dec 2021 15:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD4CC341C1;
        Mon,  6 Dec 2021 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803630;
        bh=Deu1GMJmchFX9Y13+caJe0ysu1S53HHLqp6oMvQG3zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9zA1bZe/46rGSlGMWI3ufQrApUonuQ+ZOtrLPMLq2ksn1q66XZ9cU5MvsdbZlQvk
         g/D1TO24AJcimI9eOvgvEsLuDR8XHVYF2TihdFgF4JIj04R7oLJVMkwbAVEnB8wXvQ
         4WpXK/rU93zpVR2vv2fUOll2Mj6DtrT11HXpD+po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>
Subject: [PATCH 5.4 29/70] fget: check that the fd still exists after getting a ref to it
Date:   Mon,  6 Dec 2021 15:56:33 +0100
Message-Id: <20211206145552.929775417@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 054aa8d439b9185d4f5eb9a90282d1ce74772969 upstream.

Jann Horn points out that there is another possible race wrt Unix domain
socket garbage collection, somewhat reminiscent of the one fixed in
commit cbcf01128d0a ("af_unix: fix garbage collect vs MSG_PEEK").

See the extended comment about the garbage collection requirements added
to unix_peek_fds() by that commit for details.

The race comes from how we can locklessly look up a file descriptor just
as it is in the process of being closed, and with the right artificial
timing (Jann added a few strategic 'mdelay(500)' calls to do that), the
Unix domain socket garbage collector could see the reference count
decrement of the close() happen before fget() took its reference to the
file and the file was attached onto a new file descriptor.

This is all (intentionally) correct on the 'struct file *' side, with
RCU lookups and lockless reference counting very much part of the
design.  Getting that reference count out of order isn't a problem per
se.

But the garbage collector can get confused by seeing this situation of
having seen a file not having any remaining external references and then
seeing it being attached to an fd.

In commit cbcf01128d0a ("af_unix: fix garbage collect vs MSG_PEEK") the
fix was to serialize the file descriptor install with the garbage
collector by taking and releasing the unix_gc_lock.

That's not really an option here, but since this all happens when we are
in the process of looking up a file descriptor, we can instead simply
just re-check that the file hasn't been closed in the meantime, and just
re-do the lookup if we raced with a concurrent close() of the same file
descriptor.

Reported-and-tested-by: Jann Horn <jannh@google.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -723,6 +723,10 @@ loop:
 			file = NULL;
 		else if (!get_file_rcu_many(file, refs))
 			goto loop;
+		else if (__fcheck_files(files, fd) != file) {
+			fput_many(file, refs);
+			goto loop;
+		}
 	}
 	rcu_read_unlock();
 


