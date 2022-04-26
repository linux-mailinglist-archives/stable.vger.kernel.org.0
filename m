Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79345107F4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353585AbiDZTFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352919AbiDZTFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7319319916C;
        Tue, 26 Apr 2022 12:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DE72619C0;
        Tue, 26 Apr 2022 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5839CC385BE;
        Tue, 26 Apr 2022 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999723;
        bh=Q9u6Gz6M80SVS5hvS/h6zXfSYjFBtPvZlCANhhT/kOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg18GbcoTZ/GI5rYwNzq5GCVZgTBFUF32g84TP8TfOEtLMGsfSGn92sGVk6eLwfmd
         Sl71eUq7kKzc24GRTSP/fos6Hn4wQqzCrbSDChZlJkE38GEbmxdvIHZRTs131mRQLY
         MB3dzFI0TOOHaHQXYjGbYp6tJRRRpt91y/uNywmN8dgprZEo/4moQCCidKosARejPe
         UFErS+rdMSpmrh4hdc50vBmMIINMOuPCX/pQ1kX/dnrq7mDa65u/Cb0oZ2cHDSV7Ds
         TIkDttUIsbYHxhx/clLtSGKRm1F572lrpzB0xj7KWKW3TWThMRT5scJ7eHNlVMOYgU
         CbwZB3tbxIHug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 10/22] ksmbd: increment reference count of parent fp
Date:   Tue, 26 Apr 2022 15:01:33 -0400
Message-Id: <20220426190145.2351135-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
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
index 67e8e28e3fc3..a19a2b9c1e56 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5771,8 +5771,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
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

