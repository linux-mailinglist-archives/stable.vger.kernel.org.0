Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3336D488E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjDCO3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjDCO3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:29:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A61B31985
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2AEAB81C35
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302DBC433A0;
        Mon,  3 Apr 2023 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532174;
        bh=q8bhXhQBVjJGjPd/SgUlpYFowjC+Tyl/84S5+1gBDEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwBbECP4QZkAmdHaio6d8R5Ia34+Trj7PosbG+YF6RbGdpZHacJF7la5/juj8rUBb
         GqAb7uIMajgVz/DmlJgCvopsphWAWiBNxGbAKAnl6X2HioQApCwI2fVBVXFUpNvsjn
         TUkZA46aHfJJF1YX34s5yDkxbAnpNkD9o52mmmsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Disseldorp <ddiss@suse.de>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 148/173] cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL
Date:   Mon,  3 Apr 2023 16:09:23 +0200
Message-Id: <20230403140419.242312919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -126,7 +126,10 @@ extern const struct dentry_operations ci
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


