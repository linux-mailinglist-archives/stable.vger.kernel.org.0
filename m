Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB90037874E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbhEJLPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236259AbhEJLHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8176561954;
        Mon, 10 May 2021 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644364;
        bh=EDuQGDSWvy3peju04Ji5/t2596MdhKU1EemSBf2j53E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spIKQOASarFPp2ZHEUmd/nsxEDAO+GmJKeR/BifBqAfEXzzXPHkHoR5pNIvF6CiLm
         Akul7Z27DfY7/xyGnUiw54vortOC0IamQGy2S5PNYvb49u8XS6njNoC7ya5XOWO9ZU
         yAMXrJUpZ0t3OXI2qu4P84yYK4+aQgvtwpe5zzIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 053/384] cifs: fix leak in cifs_smb3_do_mount() ctx
Date:   Mon, 10 May 2021 12:17:22 +0200
Message-Id: <20210510102016.625918286@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

commit 315db9a05b7a56810728589baa930864107e4634 upstream.

cifs_smb3_do_mount() calls smb3_fs_context_dup() and then
cifs_setup_volume_info(). The latter's subsequent smb3_parse_devname()
call overwrites the cifs_sb->ctx->UNC string already dup'ed by
smb3_fs_context_dup(), resulting in a leak. E.g.

unreferenced object 0xffff888002980420 (size 32):
  comm "mount", pid 160, jiffies 4294892541 (age 30.416s)
  hex dump (first 32 bytes):
    5c 5c 31 39 32 2e 31 36 38 2e 31 37 34 2e 31 30  \\192.168.174.10
    34 5c 72 61 70 69 64 6f 2d 73 68 61 72 65 00 00  4\rapido-share..
  backtrace:
    [<00000000069e12f6>] kstrdup+0x28/0x50
    [<00000000b61f4032>] smb3_fs_context_dup+0x127/0x1d0 [cifs]
    [<00000000c6e3e3bf>] cifs_smb3_do_mount+0x77/0x660 [cifs]
    [<0000000063467a6b>] smb3_get_tree+0xdf/0x220 [cifs]
    [<00000000716f731e>] vfs_get_tree+0x1b/0x90
    [<00000000491d3892>] path_mount+0x62a/0x910
    [<0000000046b2e774>] do_mount+0x50/0x70
    [<00000000ca7b64dd>] __x64_sys_mount+0x81/0xd0
    [<00000000b5122496>] do_syscall_64+0x33/0x40
    [<000000002dd397af>] entry_SYSCALL_64_after_hwframe+0x44/0xae

This change is a bandaid until the cifs_setup_volume_info() TODO and
error handling issues are resolved.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
CC: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -834,6 +834,12 @@ cifs_smb3_do_mount(struct file_system_ty
 		goto out;
 	}
 
+	/* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
+	kfree(cifs_sb->ctx->UNC);
+	cifs_sb->ctx->UNC = NULL;
+	kfree(cifs_sb->ctx->prepath);
+	cifs_sb->ctx->prepath = NULL;
+
 	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
 	if (rc) {
 		root = ERR_PTR(rc);


