Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CACC4B7144
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbiBOPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:31:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240164AbiBOPa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D987B5601;
        Tue, 15 Feb 2022 07:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45D47B81AFD;
        Tue, 15 Feb 2022 15:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2292DC36AE7;
        Tue, 15 Feb 2022 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938932;
        bh=jtUIix8YE2fPyTynYc8qgmVp0lmvN90YoZI+APmQjhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOyE0cSz4vqqrYWMXtxdJKVgCwgS/3+dWa0bgxUI8/0eAo+wBo5dlFDiGtWSq4p5v
         npzKdR7OnPoA15uZdp3xaKDR5wB9wD3cdgQiOxlak/NH7xTbMLd9GU4uT0Z7tNCROu
         Fvym5HfngsoN3dgrFXsNZj8R6pH0R4cSWprGeP2URdjQLT7yHFL9pjjqwMhglVCkz/
         CpY11YAFqY0RaWHWN5pRPUJxh+8GU81acdMj7pOczaHSYdSi7O2CW0ViYZRlbNRhrc
         C1eS+NpJJr+IKusUcVJ9j9cKiqHkEh2yJALnheLmtHLmJMJUdjDG1MBEtQGV8FTnZ3
         tHqsr7aqWmqGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, senozhatsky@chromium.org,
        sfrench@samba.org, hyc.lee@gmail.com, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/33] ksmbd: fix same UniqueId for dot and dotdot entries
Date:   Tue, 15 Feb 2022 10:28:08 -0500
Message-Id: <20220215152831.580780-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 97550c7478a2da93e348d8c3075d92cddd473a78 ]

ksmbd sets the inode number to UniqueId. However, the same UniqueId for
dot and dotdot entry is set to the inode number of the parent inode.
This patch set them using the current inode and parent inode.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 707490ab1f4c4..f2e7e3a654b34 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -308,14 +308,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 	for (i = 0; i < 2; i++) {
 		struct kstat kstat;
 		struct ksmbd_kstat ksmbd_kstat;
+		struct dentry *dentry;
 
 		if (!dir->dot_dotdot[i]) { /* fill dot entry info */
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
+				dentry = dir->filp->f_path.dentry;
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
+				dentry = dir->filp->f_path.dentry->d_parent;
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
@@ -327,7 +330,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			ksmbd_kstat.kstat = &kstat;
 			ksmbd_vfs_fill_dentry_attrs(work,
 						    user_ns,
-						    dir->filp->f_path.dentry->d_parent,
+						    dentry,
 						    &ksmbd_kstat);
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
-- 
2.34.1

