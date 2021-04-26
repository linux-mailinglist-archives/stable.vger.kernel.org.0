Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F9536AD8B
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhDZHhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhDZHgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78329613B4;
        Mon, 26 Apr 2021 07:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422464;
        bh=8b/UESAFuM/D3n30GmOT9CfrfzYYQIk1UcWOMukmSqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlheE1cTXJvpDb8B26AKDQwHFpro0vduEijBzn+1dJMsIOQVpKDsXm/nd5xSl+dyx
         IcdyNQpdYB2E2ytQqhfH0ZgvUZYvRI5yZcCIG+PvYt8gabTmYJoGrAXRQKo3/8WKi8
         UzkzhPEvM8jehATptcEWDUug0jOscZ8el5P0w/O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 22/49] readdir: make sure to verify directory entry for legacy interfaces too
Date:   Mon, 26 Apr 2021 09:29:18 +0200
Message-Id: <20210426072820.480252806@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0c93ac69407d63a85be0129aa55ffaec27ffebd3 upstream.

This does the directory entry name verification for the legacy
"fillonedir" (and compat) interface that goes all the way back to the
dark ages before we had a proper dirent, and the readdir() system call
returned just a single entry at a time.

Nobody should use this interface unless you still have binaries from
1991, but let's do it right.

This came up during discussions about unsafe_copy_to_user() and proper
checking of all the inputs to it, as the networking layer is looking to
use it in a few new places.  So let's make sure the _old_ users do it
all right and proper, before we add new ones.

See also commit 8a23eb804ca4 ("Make filldir[64]() verify the directory
entry filename is valid") which did the proper modern interfaces that
people actually use. It had a note:

    Note that I didn't bother adding the checks to any legacy interfaces
    that nobody uses.

which this now corrects.  Note that we really don't care about POSIX and
the presense of '/' in a directory entry, but verify_dirent_name() also
ends up doing the proper name length verification which is what the
input checking discussion was about.

[ Another option would be to remove the support for this particular very
  old interface: any binaries that use it are likely a.out binaries, and
  they will no longer run anyway since we removed a.out binftm support
  in commit eac616557050 ("x86: Deprecate a.out support").

  But I'm not sure which came first: getdents() or ELF support, so let's
  pretend somebody might still have a working binary that uses the
  legacy readdir() case.. ]

Link: https://lore.kernel.org/lkml/CAHk-=wjbvzCAhAtvG0d81W5o0-KT5PPTHhfJ5ieDFq+bGtgOYg@mail.gmail.com/
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/readdir.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -133,6 +133,9 @@ static int fillonedir(struct dir_context
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = verify_dirent_name(name, namlen);
+	if (buf->result < 0)
+		return buf->result;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
@@ -392,6 +395,9 @@ static int compat_fillonedir(struct dir_
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = verify_dirent_name(name, namlen);
+	if (buf->result < 0)
+		return buf->result;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;


