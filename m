Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6098146A9AD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350894AbhLFVTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47644 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350771AbhLFVSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:18:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBF86CE1847;
        Mon,  6 Dec 2021 21:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A9C341C1;
        Mon,  6 Dec 2021 21:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825312;
        bh=OFVZkVdi1U58Sy2A1lkOM3n5NH/11bZ3bGHBsyzhAFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDmTwzSfodxz8zkgJNIwC9XK7/80kDgWTWc0w/PZxGC2GQEjmcjGnUMPJEQGtgZSg
         vQ9wWQYYLA8o2r6dmQ4u0HfikiOBW/NtNBMwPZsAdz3K+q4IG38Ck2VyQvNVvVPOt+
         9n9HdtKtxCaTTSt6WOSs8DHbmUlNeTQTyZBkTeQkf+fr3BCFXP5IySyBJKbpUWeiOW
         8cPdxq/maYucj4uqQNBfXiNvfjFMpfJNrER1oac8tTkx979fK/oX6cvo3rZVYZQb/5
         Ueqe4Yw7k0nNFHBAvZ/e1qzoQwWgSySZ5tAStAMeYjBDsj1WIjGKi4py0hbfBhnPEG
         0rljRP2rvlgcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/24] fget: check that the fd still exists after getting a ref to it
Date:   Mon,  6 Dec 2021 16:12:29 -0500
Message-Id: <20211206211230.1660072-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 054aa8d439b9185d4f5eb9a90282d1ce74772969 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 8627dacfc4246..ad4a8bf3cf109 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -858,6 +858,10 @@ static struct file *__fget_files(struct files_struct *files, unsigned int fd,
 			file = NULL;
 		else if (!get_file_rcu_many(file, refs))
 			goto loop;
+		else if (files_lookup_fd_raw(files, fd) != file) {
+			fput_many(file, refs);
+			goto loop;
+		}
 	}
 	rcu_read_unlock();
 
-- 
2.33.0

