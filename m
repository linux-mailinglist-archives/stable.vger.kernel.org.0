Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37BCA7D3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405889AbfJCQuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404439AbfJCQuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A122086A;
        Thu,  3 Oct 2019 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121405;
        bh=Pked2uDDLVovjt6dOYD0c9fDApYqn3LgQwFvjn28zlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQgxSNTwszYZqgQ7oRl8IJAPIcthMpKTHf9B5eUruW48gO3uhFp8UYCCZW8HXuLvY
         JDAcIL/ks14DHSDSqqjIzI5Y4xce8ikZH/krZmRw3Vq6+KUHPIe8e5e2avkxn1Jxok
         dB0LMntQBJA+aCYXLHIiZO/rHDyYLOHYvtUp5Sog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.3 259/344] fuse: fix beyond-end-of-page access in fuse_parse_cache()
Date:   Thu,  3 Oct 2019 17:53:44 +0200
Message-Id: <20191003154606.040928851@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit e5854b1cdf6cb48a20e01e3bdad0476a4c60a077 upstream.

With DEBUG_PAGEALLOC on, the following triggers.

  BUG: unable to handle page fault for address: ffff88859367c000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 3001067 P4D 3001067 PUD 406d3a8067 PMD 406d30c067 PTE 800ffffa6c983060
  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
  CPU: 38 PID: 3110657 Comm: python2.7
  RIP: 0010:fuse_readdir+0x88f/0xe7a [fuse]
  Code: 49 8b 4d 08 49 39 4e 60 0f 84 44 04 00 00 48 8b 43 08 43 8d 1c 3c 4d 01 7e 68 49 89 dc 48 03 5c 24 38 49 89 46 60 8b 44 24 30 <8b> 4b 10 44 29 e0 48 89 ca 48 83 c1 1f 48 83 e1 f8 83 f8 17 49 89
  RSP: 0018:ffffc90035edbde0 EFLAGS: 00010286
  RAX: 0000000000001000 RBX: ffff88859367bff0 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffff88859367bfed RDI: 0000000000920907
  RBP: ffffc90035edbe90 R08: 000000000000014b R09: 0000000000000004
  R10: ffff88859367b000 R11: 0000000000000000 R12: 0000000000000ff0
  R13: ffffc90035edbee0 R14: ffff889fb8546180 R15: 0000000000000020
  FS:  00007f80b5f4a740(0000) GS:ffff889fffa00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff88859367c000 CR3: 0000001c170c2001 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   iterate_dir+0x122/0x180
   __x64_sys_getdents+0xa6/0x140
   do_syscall_64+0x42/0x100
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

It's in fuse_parse_cache().  %rbx (ffff88859367bff0) is fuse_dirent
pointer - addr + offset.  FUSE_DIRENT_SIZE() is trying to dereference
namelen off of it but that derefs into the next page which is disabled
by pagealloc debug causing a PF.

This is caused by dirent->namelen being accessed before ensuring that
there's enough bytes in the page for the dirent.  Fix it by pushing
down reclen calculation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 5d7bc7e8680c ("fuse: allow using readdir cache")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/readdir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -372,11 +372,13 @@ static enum fuse_parse_result fuse_parse
 	for (;;) {
 		struct fuse_dirent *dirent = addr + offset;
 		unsigned int nbytes = size - offset;
-		size_t reclen = FUSE_DIRENT_SIZE(dirent);
+		size_t reclen;
 
 		if (nbytes < FUSE_NAME_OFFSET || !dirent->namelen)
 			break;
 
+		reclen = FUSE_DIRENT_SIZE(dirent); /* derefs ->namelen */
+
 		if (WARN_ON(dirent->namelen > FUSE_NAME_MAX))
 			return FOUND_ERR;
 		if (WARN_ON(reclen > nbytes))


