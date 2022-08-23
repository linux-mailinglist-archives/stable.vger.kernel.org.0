Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A073B59D3AB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiHWIJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241784AbiHWIJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC18B19009;
        Tue, 23 Aug 2022 01:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 854B26123D;
        Tue, 23 Aug 2022 08:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F632C433D6;
        Tue, 23 Aug 2022 08:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241947;
        bh=81egiymmXjie7ZfHht3gdCJoD5Cj2oCSFmSjn1h7CzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mD7lzOGZqst8fHB1ekQXgyuhzbJjlYm77FdkvdA7jp3IAaD2bYtq/JDf36s7YXMad
         J6GmQLzARCggrjvndDapZu/YKMDSTjBktQTDpw/LrnBoDoQ0ruN4yvdMSvfUjb0fh1
         cNsXVktbRxFkPQ5wPaql82eZqF5Uo+lk8D/CYje0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 028/365] cifs: Fix memory leak on the deferred close
Date:   Tue, 23 Aug 2022 09:58:49 +0200
Message-Id: <20220823080119.402472666@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit ca08d0eac020d48a3141dbec0a3cf64fbdb17cde upstream.

xfstests on smb21 report kmemleak as below:

  unreferenced object 0xffff8881767d6200 (size 64):
    comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
    hex dump (first 32 bytes):
      80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c....
      00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v............
    backtrace:
      [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
      [<0000000028b93c82>] __fput+0xff/0x3f0
      [<00000000d8116851>] task_work_run+0x85/0xc0
      [<0000000027e14f9e>] do_exit+0x5e5/0x1240
      [<00000000fb492b95>] do_group_exit+0x58/0xe0
      [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
      [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
      [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

When cancel the deferred close work, we should also cleanup the struct
cifs_deferred_close.

Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/rename/lease break.")
Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/misc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -742,6 +742,8 @@ cifs_close_deferred_file(struct cifsInod
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -773,6 +775,8 @@ cifs_close_all_deferred_files(struct cif
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -808,6 +812,8 @@ cifs_close_deferred_file_under_dentry(st
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
 				if (cancel_delayed_work(&cfile->deferred)) {
+					cifs_del_deferred_close(cfile);
+
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 					if (tmp_list == NULL)
 						break;


