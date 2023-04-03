Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A153C6D48FC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjDCOdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbjDCOdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:33:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B091767A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69D96B81C6F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866CC433EF;
        Mon,  3 Apr 2023 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532401;
        bh=blv3SW+RxsWGacT544sbFgefBCcLM8E7IYPNXmNLpPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztyhDoDqvHwYwgCIy/e1SqBdKEKKBv6WEewbaduxjaDs3FgPfC/my10HcfCr4rYEA
         Av3ozoubTGTbF/LKLUJwmnZ0wxRZIUu5Y0rmMuFm0H338PGHvOydSbDVlWDn0Bj6Co
         9J7M8VOrIGCf0kCa3acq8HfvuNzuJWG0bsFdGZmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Disseldorp <ddiss@suse.de>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 68/99] cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL
Date:   Mon,  3 Apr 2023 16:09:31 +0200
Message-Id: <20230403140406.044966453@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

commit 179a88a8558bbf42991d361595281f3e45d7edfc upstream.

When compiled with CONFIG_CIFS_DFS_UPCALL disabled, cifs_dfs_d_automount
is NULL. cifs.ko logic for mapping CIFS_FATTR_DFS_REFERRAL attributes to
S_AUTOMOUNT and corresponding dentry flags is retained regardless of
CONFIG_CIFS_DFS_UPCALL, leading to a NULL pointer dereference in
VFS follow_automount() when traversing a DFS referral link:
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  Call Trace:
   <TASK>
   __traverse_mounts+0xb5/0x220
   ? cifs_revalidate_mapping+0x65/0xc0 [cifs]
   step_into+0x195/0x610
   ? lookup_fast+0xe2/0xf0
   path_lookupat+0x64/0x140
   filename_lookup+0xc2/0x140
   ? __create_object+0x299/0x380
   ? kmem_cache_alloc+0x119/0x220
   ? user_path_at_empty+0x31/0x50
   user_path_at_empty+0x31/0x50
   __x64_sys_chdir+0x2a/0xd0
   ? exit_to_user_mode_prepare+0xca/0x100
   do_syscall_64+0x42/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

This fix adds an inline cifs_dfs_d_automount() {return -EREMOTE} handler
when CONFIG_CIFS_DFS_UPCALL is disabled. An alternative would be to
avoid flagging S_AUTOMOUNT, etc. without CONFIG_CIFS_DFS_UPCALL. This
approach was chosen as it provides more control over the error path.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -118,7 +118,10 @@ extern const struct dentry_operations ci
 #ifdef CONFIG_CIFS_DFS_UPCALL
 extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
 #else
-#define cifs_dfs_d_automount NULL
+static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
+{
+	return ERR_PTR(-EREMOTE);
+}
 #endif
 
 /* Functions related to symlinks */


