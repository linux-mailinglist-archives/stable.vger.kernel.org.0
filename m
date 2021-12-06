Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6F6469C81
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358157AbhLFPXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244321AbhLFPVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B07B810AC;
        Mon,  6 Dec 2021 15:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6FAC341C2;
        Mon,  6 Dec 2021 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803852;
        bh=2EnuHbpwEdNdoBrFkfdLNPESzeoOC8kASvGtg8RUx0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2189ND67vWxu2IxXz6vw7GShRs5rip95cJ+2lgRWR/MtQY993uJYcRLvaIv9K0mH
         X4x2vI9q6U7etf2C/cKWdwC1UwEyQtvUDrPgKDZGR7A6ATkZefBfcaeqWU/FzfWlXx
         iOD2mmayyh8Aub/iF2NbkU6CfotmOi/HILUPbGrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>
Subject: [PATCH 5.10 037/130] fget: check that the fd still exists after getting a ref to it
Date:   Mon,  6 Dec 2021 15:55:54 +0100
Message-Id: <20211206145600.955089153@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
@@ -834,6 +834,10 @@ loop:
 			file = NULL;
 		else if (!get_file_rcu_many(file, refs))
 			goto loop;
+		else if (__fcheck_files(files, fd) != file) {
+			fput_many(file, refs);
+			goto loop;
+		}
 	}
 	rcu_read_unlock();
 


