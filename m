Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA89A65848F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiL1Q61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiL1Q5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FBB1DDF3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77F246156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E463C433EF;
        Wed, 28 Dec 2022 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246438;
        bh=rATO7hyXZhsZFy/nwAYlJiwB7JrVoHnWjvyrZrGl4gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jXZYgWt4zWAxMLwCjMztrT3X281Obk95pFNH56e2DoJGRqBJ7c+TFy10v1HwOETJ
         k2m4IVb+LRpWcmNqhrAYUF8wjmOwuoXI/qHYlCCKZrJPZpRrv3oUsH4ST8m/EaigZ0
         HkHQP9vMBr3n/4AGxe48Kw+XVlzJ4oGUFUtyiiwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 1072/1073] cifs: fix memory leaks in session setup
Date:   Wed, 28 Dec 2022 15:44:20 +0100
Message-Id: <20221228144357.357931147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 01f2ee7e325611524078009d70392a5d5eca0945 upstream.

We were only zeroing out the ntlmssp blob but forgot to free the
allocated buffer in the end of SMB2_sess_auth_rawntlmssp_negotiate()
and SMB2_sess_auth_rawntlmssp_authenticate() functions.

This fixes below kmemleak reports:

unreferenced object 0xffff88800ddcfc60 (size 96):
  comm "mount.cifs", pid 758, jiffies 4294696066 (age 42.967s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d0beeb29>] __kmalloc+0x39/0xa0
    [<00000000e3834047>] build_ntlmssp_smb3_negotiate_blob+0x2c/0x110 [cifs]
    [<00000000e85f5ab2>] SMB2_sess_auth_rawntlmssp_negotiate+0xd3/0x230 [cifs]
    [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
    [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
    [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
    [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
    [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
    [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
    [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
    [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
    [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
    [<000000003a8561de>] path_mount+0x2d3/0xb50
    [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
    [<00000000142142f3>] do_syscall_64+0x3b/0x90
    [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff88801437f000 (size 512):
  comm "mount.cifs", pid 758, jiffies 4294696067 (age 42.970s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d0beeb29>] __kmalloc+0x39/0xa0
    [<00000000004f53d2>] build_ntlmssp_auth_blob+0x4f/0x340 [cifs]
    [<000000005f333084>] SMB2_sess_auth_rawntlmssp_authenticate+0xd4/0x250 [cifs]
    [<0000000080fdb897>] SMB2_sess_setup+0x16c/0x2a0 [cifs]
    [<000000009af320a8>] cifs_setup_session+0x13b/0x370 [cifs]
    [<00000000f15d5982>] cifs_get_smb_ses+0x643/0xb90 [cifs]
    [<00000000fe15eb90>] mount_get_conns+0x63/0x3e0 [cifs]
    [<00000000768aba03>] mount_get_dfs_conns+0x16/0xa0 [cifs]
    [<00000000cf1cf146>] cifs_mount+0x1c2/0x9a0 [cifs]
    [<000000000d66b51e>] cifs_smb3_do_mount+0x10e/0x710 [cifs]
    [<0000000077a996c5>] smb3_get_tree+0xf4/0x200 [cifs]
    [<0000000094dbd041>] vfs_get_tree+0x23/0xc0
    [<000000003a8561de>] path_mount+0x2d3/0xb50
    [<00000000ed5c86d6>] __x64_sys_mount+0x102/0x140
    [<00000000142142f3>] do_syscall_64+0x3b/0x90
    [<00000000e2b89731>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1345,14 +1345,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_
 static void
 SMB2_sess_free_buffer(struct SMB2_sess_data *sess_data)
 {
-	int i;
+	struct kvec *iov = sess_data->iov;
 
-	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
-	for (i = 0; i < 2; i++)
-		if (sess_data->iov[i].iov_base)
-			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+	/* iov[1] is already freed by caller */
+	if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
+		memzero_explicit(iov[0].iov_base, iov[0].iov_len);
 
-	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
+	free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
 }
 
@@ -1582,7 +1581,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(stru
 	}
 
 out:
-	memzero_explicit(ntlmssp_blob, blob_length);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
 	if (!rc) {
 		sess_data->result = 0;
@@ -1666,7 +1665,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(s
 	}
 #endif
 out:
-	memzero_explicit(ntlmssp_blob, blob_length);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
 	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;


