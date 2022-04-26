Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EA51082D
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353788AbiDZTFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353754AbiDZTFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A101999D5;
        Tue, 26 Apr 2022 12:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D99619C4;
        Tue, 26 Apr 2022 19:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E848C385AD;
        Tue, 26 Apr 2022 19:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999742;
        bh=pH8kHLg29q84DA3lAKF1knzAlPKUewGQtsmALlQhDkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUv44KYMyRgUcmKqs/27GHZ/Y71e5ZCVC0uIqBeuSRj5yiVapBrKYFQC5UhGzBuQZ
         wZhD/aovSLGSI3C7awdN+oSxT/82X3XMgC2icnNsRPjICN2vU/uHYA2U2aSaCrt2J1
         Ebrk4YfaeVho8QM14xJZE8Y5ptU4tQX0U5PZXM92XbPIDxsmIYyu/OZQxnSx6GgtO4
         7VIvV1QgLWQKtwGICLStKG3WLJvXUG1twJA7M1teO/NpiKE6ih+bqTkG/rtSpM9DKr
         g0utMUEQE3Ce+OnN+qexbY2aftP7Q1JPJKCEhGsnpjM5Jb7eRirplsiUA2b6fOk3c/
         HoW6nwRe5+ilA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/15] ksmbd: increment reference count of parent fp
Date:   Tue, 26 Apr 2022 15:02:04 -0400
Message-Id: <20220426190216.2351413-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 8510a043d334ecdf83d4604782f288db6bf21d60 ]

Add missing increment reference count of parent fp in
ksmbd_lookup_fd_inode().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c   | 2 ++
 fs/ksmbd/vfs_cache.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 192d8308afc2..a9fdb47c2791 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5768,8 +5768,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
 			pr_err("parent dir is opened with delete access\n");
+			ksmbd_fd_put(work, parent_fp);
 			return -ESHARE;
 		}
+		ksmbd_fd_put(work, parent_fp);
 	}
 next:
 	return smb2_rename(work, fp, user_ns, rename_info,
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 29c1db66bd0f..8b873d92d785 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -497,6 +497,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
+			lfp = ksmbd_fp_get(lfp);
 			read_unlock(&ci->m_lock);
 			return lfp;
 		}
-- 
2.35.1

