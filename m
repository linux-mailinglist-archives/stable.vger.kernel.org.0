Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7974428B986
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgJLNig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgJLNhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2611D2222C;
        Mon, 12 Oct 2020 13:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509832;
        bh=/jWJGjqXGhUVTsyD5dxMjb9z7x95VV2arf08gTsGXX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS8bx/8+8C6PTJhHDdcE1KQScfwS6WPMK368c/AJrgZ3G/Se8oCBboy/C+soFWI1w
         HjnPYMLD56t7EbJ5j0V5xKGJZRyOMh9ZkygY/lXRUjCjasocCOAA8GIyZzWH64ujAH
         /5siehO5Wf6pYoPrg7zuAVA8WygDA9bnEg69IGLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vladimir@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 47/70] cifs: Fix incomplete memory allocation on setxattr path
Date:   Mon, 12 Oct 2020 15:27:03 +0200
Message-Id: <20201012132632.453265979@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir@tuxera.com>

commit 64b7f674c292207624b3d788eda2dde3dc1415df upstream.

On setxattr() syscall path due to an apprent typo the size of a dynamically
allocated memory chunk for storing struct smb2_file_full_ea_info object is
computed incorrectly, to be more precise the first addend is the size of
a pointer instead of the wanted object size. Coincidentally it makes no
difference on 64-bit platforms, however on 32-bit targets the following
memcpy() writes 4 bytes of data outside of the dynamically allocated memory.

  =============================================================================
  BUG kmalloc-16 (Not tainted): Redzone overwritten
  -----------------------------------------------------------------------------

  Disabling lock debugging due to kernel taint
  INFO: 0x79e69a6f-0x9e5cdecf @offset=368. First byte 0x73 instead of 0xcc
  INFO: Slab 0xd36d2454 objects=85 used=51 fp=0xf7d0fc7a flags=0x35000201
  INFO: Object 0x6f171df3 @offset=352 fp=0x00000000

  Redzone 5d4ff02d: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  Object 6f171df3: 00 00 00 00 00 05 06 00 73 6e 72 75 62 00 66 69  ........snrub.fi
  Redzone 79e69a6f: 73 68 32 0a                                      sh2.
  Padding 56254d82: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
  CPU: 0 PID: 8196 Comm: attr Tainted: G    B             5.9.0-rc8+ #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
  Call Trace:
   dump_stack+0x54/0x6e
   print_trailer+0x12c/0x134
   check_bytes_and_report.cold+0x3e/0x69
   check_object+0x18c/0x250
   free_debug_processing+0xfe/0x230
   __slab_free+0x1c0/0x300
   kfree+0x1d3/0x220
   smb2_set_ea+0x27d/0x540
   cifs_xattr_set+0x57f/0x620
   __vfs_setxattr+0x4e/0x60
   __vfs_setxattr_noperm+0x4e/0x100
   __vfs_setxattr_locked+0xae/0xd0
   vfs_setxattr+0x4e/0xe0
   setxattr+0x12c/0x1a0
   path_setxattr+0xa4/0xc0
   __ia32_sys_lsetxattr+0x1d/0x20
   __do_fast_syscall_32+0x40/0x70
   do_fast_syscall_32+0x29/0x60
   do_SYSENTER_32+0x15/0x20
   entry_SYSENTER_32+0x9f/0xf2

Fixes: 5517554e4313 ("cifs: Add support for writing attributes on SMB2+")
Signed-off-by: Vladimir Zapolskiy <vladimir@tuxera.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -652,7 +652,7 @@ smb2_set_ea(const unsigned int xid, stru
 		return rc;
 	}
 
-	len = sizeof(ea) + ea_name_len + ea_value_len + 1;
+	len = sizeof(*ea) + ea_name_len + ea_value_len + 1;
 	ea = kzalloc(len, GFP_KERNEL);
 	if (ea == NULL) {
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);


