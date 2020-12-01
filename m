Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76742C9D24
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbgLAJTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389618AbgLAJKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68062206D8;
        Tue,  1 Dec 2020 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813760;
        bh=Xz7ZAgNXRZZqiaTWQSGl8K/kPFExL0zwfzesaSKfLng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZaNlXbqPxfxOn/nQ6MRY5LLvt2Rh45qVG98k65dEBmk27r1oKIclpgrf14uomBcf
         exCIXMdiqe7LhkbQIXmg9KvsAXC7K/C1VMXUJb3holCiil50Bav+wBU2eCw1xAWmBH
         JIOCBX0A2wvKwTmESiDA7faXWSQpxiVqfbr8SrMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 019/152] cifs: fix a memleak with modefromsid
Date:   Tue,  1 Dec 2020 09:52:14 +0100
Message-Id: <20201201084714.380468831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 98128572084c3dd8067f48bb588aa3733d1355b5 upstream.

kmemleak reported a memory leak allocated in query_info() when cifs is
working with modefromsid.

  backtrace:
    [<00000000aeef6a1e>] slab_post_alloc_hook+0x58/0x510
    [<00000000b2f7a440>] __kmalloc+0x1a0/0x390
    [<000000006d470ebc>] query_info+0x5b5/0x700 [cifs]
    [<00000000bad76ce0>] SMB2_query_acl+0x2b/0x30 [cifs]
    [<000000001fa09606>] get_smb2_acl_by_path+0x2f3/0x720 [cifs]
    [<000000001b6ebab7>] get_smb2_acl+0x75/0x90 [cifs]
    [<00000000abf43904>] cifs_acl_to_fattr+0x13b/0x1d0 [cifs]
    [<00000000a5372ec3>] cifs_get_inode_info+0x4cd/0x9a0 [cifs]
    [<00000000388e0a04>] cifs_revalidate_dentry_attr+0x1cd/0x510 [cifs]
    [<0000000046b6b352>] cifs_getattr+0x8a/0x260 [cifs]
    [<000000007692c95e>] vfs_getattr_nosec+0xa1/0xc0
    [<00000000cbc7d742>] vfs_getattr+0x36/0x40
    [<00000000de8acf67>] vfs_statx_fd+0x4a/0x80
    [<00000000a58c6adb>] __do_sys_newfstat+0x31/0x70
    [<00000000300b3b4e>] __x64_sys_newfstat+0x16/0x20
    [<000000006d8e9c48>] do_syscall_64+0x37/0x80

This patch add missing kfree for pntsd when mounting modefromsid option.

Cc: Stable <stable@vger.kernel.org> # v5.4+
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsacl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1266,6 +1266,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *c
 		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
 	} else if (mode_from_special_sid) {
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr, true);
+		kfree(pntsd);
 	} else {
 		/* get approximated mode from ACL */
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr, false);


