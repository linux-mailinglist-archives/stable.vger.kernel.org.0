Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3E0206322
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbgFWUR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389553AbgFWURY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574ED20E65;
        Tue, 23 Jun 2020 20:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943444;
        bh=lzYnvigC7sLlpJXIV5q49x/6vjpAsUoOiwW9WvA8Mfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kWSRn5z9VKOTFDS28MXWjeDxVJHoFyykHN49UTaSDqCT6luslkrvAroOxRJt8CwR
         qO+M7059gWRWN850nsvcf7obtVlKKHm4xnACaE7EM4HiMiX6koGWQCPu31vrickBl/
         Hi0z/YakTBp5PLJY2CrDzzpPSpFmX4yYRSIAt5V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 394/477] afs: Fix EOF corruption
Date:   Tue, 23 Jun 2020 21:56:31 +0200
Message-Id: <20200623195426.150729212@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3f4aa981816368fe6b1d13c2bfbe76df9687e787 ]

When doing a partial writeback, afs_write_back_from_locked_page() may
generate an FS.StoreData RPC request that writes out part of a file when a
file has been constructed from pieces by doing seek, write, seek, write,
... as is done by ld.

The FS.StoreData RPC is given the current i_size as the file length, but
the server basically ignores it unless the data length is 0 (in which case
it's just a truncate operation).  The revised file length returned in the
result of the RPC may then not reflect what we suggested - and this leads
to i_size getting moved backwards - which causes issues later.

Fix the client to take account of this by ignoring the returned file size
unless the data version number jumped unexpectedly - in which case we're
going to have to clear the pagecache and reload anyway.

This can be observed when doing a kernel build on an AFS mount.  The
following pair of commands produce the issue:

  ld -m elf_x86_64 -z max-page-size=0x200000 --emit-relocs \
      -T arch/x86/realmode/rm/realmode.lds \
      arch/x86/realmode/rm/header.o \
      arch/x86/realmode/rm/trampoline_64.o \
      arch/x86/realmode/rm/stack.o \
      arch/x86/realmode/rm/reboot.o \
      -o arch/x86/realmode/rm/realmode.elf
  arch/x86/tools/relocs --realmode \
      arch/x86/realmode/rm/realmode.elf \
      >arch/x86/realmode/rm/realmode.relocs

This results in the latter giving:

	Cannot read ELF section headers 0/18: Success

as the realmode.elf file got corrupted.

The sequence of events can also be driven with:

	xfs_io -t -f \
		-c "pwrite -S 0x58 0 0x58" \
		-c "pwrite -S 0x59 10000 1000" \
		-c "close" \
		/afs/example.com/scratch/a

Fixes: 31143d5d515e ("AFS: implement basic file write support")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 281470fe1183c..a239884549c5b 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -170,6 +170,7 @@ static void afs_apply_status(struct afs_fs_cursor *fc,
 	struct timespec64 t;
 	umode_t mode;
 	bool data_changed = false;
+	bool change_size = false;
 
 	BUG_ON(test_bit(AFS_VNODE_UNSET, &vnode->flags));
 
@@ -225,6 +226,7 @@ static void afs_apply_status(struct afs_fs_cursor *fc,
 		} else {
 			set_bit(AFS_VNODE_ZAP_DATA, &vnode->flags);
 		}
+		change_size = true;
 	} else if (vnode->status.type == AFS_FTYPE_DIR) {
 		/* Expected directory change is handled elsewhere so
 		 * that we can locally edit the directory and save on a
@@ -232,11 +234,19 @@ static void afs_apply_status(struct afs_fs_cursor *fc,
 		 */
 		if (test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
 			data_changed = false;
+		change_size = true;
 	}
 
 	if (data_changed) {
 		inode_set_iversion_raw(&vnode->vfs_inode, status->data_version);
-		afs_set_i_size(vnode, status->size);
+
+		/* Only update the size if the data version jumped.  If the
+		 * file is being modified locally, then we might have our own
+		 * idea of what the size should be that's not the same as
+		 * what's on the server.
+		 */
+		if (change_size)
+			afs_set_i_size(vnode, status->size);
 	}
 }
 
-- 
2.25.1



