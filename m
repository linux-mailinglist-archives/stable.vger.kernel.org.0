Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034BC4F2EAE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355563AbiDEKU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346215AbiDEJXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21E1C8BFC;
        Tue,  5 Apr 2022 02:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B4FEB81C15;
        Tue,  5 Apr 2022 09:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B57C385D9;
        Tue,  5 Apr 2022 09:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149987;
        bh=XPMpb65O3CeKvKBW3+kH3pERPeRlgpPUhWQrxjl1KbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv0FrDt/VCjSpmZAv/8eqBnC6coPsVddu1wfyzSzZ5oPfLBbax7IJX9vnLWY0yuNH
         zJZrnBmHmMTiFv/HMhFu2xPjKe8optD/qPJkuycyve3QmpapYF47bbAceVTdO5peW3
         efkS44qQtDaA/D4ymJbH/aCmn4ynwdCgv6F4fg5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.16 0912/1017] ubifs: Rectify space amount budget for mkdir/tmpfile operations
Date:   Tue,  5 Apr 2022 09:30:25 +0200
Message-Id: <20220405070421.293866089@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit a6dab6607d4681d227905d5198710b575dbdb519 upstream.

UBIFS should make sure the flash has enough space to store dirty (Data
that is newer than disk) data (in memory), space budget is exactly
designed to do that. If space budget calculates less data than we need,
'make_reservation()' will do more work(return -ENOSPC if no free space
lelf, sometimes we can see "cannot reserve xxx bytes in jhead xxx, error
-28" in ubifs error messages) with ubifs inodes locked, which may effect
other syscalls.

A simple way to decide how much space do we need when make a budget:
See how much space is needed by 'make_reservation()' in ubifs_jnl_xxx()
function according to corresponding operation.

It's better to report ENOSPC in ubifs_budget_space(), as early as we can.

Fixes: 474b93704f32163 ("ubifs: Implement O_TMPFILE")
Fixes: 1e51764a3c2ac05 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -428,15 +428,18 @@ static int ubifs_tmpfile(struct user_nam
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1};
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
 	struct ubifs_inode *ui;
 	int err, instantiated = 0;
 	struct fscrypt_name nm;
 
 	/*
-	 * Budget request settings: new dirty inode, new direntry,
-	 * budget for dirtied inode will be released via writeback.
+	 * Budget request settings: new inode, new direntry, changing the
+	 * parent directory inode.
+	 * Allocate budget separately for new dirtied inode, the budget will
+	 * be released via writeback.
 	 */
 
 	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
@@ -979,7 +982,8 @@ static int ubifs_mkdir(struct user_names
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	int err, sz_change;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct fscrypt_name nm;
 
 	/*


