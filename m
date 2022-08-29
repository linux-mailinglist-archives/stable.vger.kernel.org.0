Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E035A482C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiH2LGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiH2LGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:06:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AFE6716A;
        Mon, 29 Aug 2022 04:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1788B80EF1;
        Mon, 29 Aug 2022 11:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCC6C433C1;
        Mon, 29 Aug 2022 11:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771069;
        bh=AXe2rJGHH3gbINqIp92wwAZPzyNJqtalEMvyoHzqLPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiZRQw2fJGQmhi/T+9YIVKv2gItFgjsowIbRR4kIM+KDp3Hn0QZMszSzjEuJqHXUH
         FDVmBW0m/Iv8drd/kn64ClVR3IJx4Kxelk2lWHoB5RQuuISrAedGyIpnT4g6MAXmtT
         rSovvYchUPwqx93hJ3j0byFmlusT/LDn1xw1ghr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/86] NFS: Dont allocate nfs_fattr on the stack in __nfs42_ssc_open()
Date:   Mon, 29 Aug 2022 12:58:42 +0200
Message-Id: <20220829105757.186805285@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 156cd28562a4e8ca454d11b234d9f634a45d6390 ]

The preferred behaviour is always to allocate struct nfs_fattr from the
slab.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 9fdecd9090493..4928eaa0d4c02 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -321,7 +321,7 @@ static int read_name_gen = 1;
 static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		struct nfs_fh *src_fh, nfs4_stateid *stateid)
 {
-	struct nfs_fattr fattr;
+	struct nfs_fattr *fattr = nfs_alloc_fattr();
 	struct file *filep, *res;
 	struct nfs_server *server;
 	struct inode *r_ino = NULL;
@@ -332,9 +332,10 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 
 	server = NFS_SERVER(ss_mnt->mnt_root->d_inode);
 
-	nfs_fattr_init(&fattr);
+	if (!fattr)
+		return ERR_PTR(-ENOMEM);
 
-	status = nfs4_proc_getattr(server, src_fh, &fattr, NULL, NULL);
+	status = nfs4_proc_getattr(server, src_fh, fattr, NULL, NULL);
 	if (status < 0) {
 		res = ERR_PTR(status);
 		goto out;
@@ -347,7 +348,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		goto out;
 	snprintf(read_name, len, SSC_READ_NAME_BODY, read_name_gen++);
 
-	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, &fattr,
+	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, fattr,
 			NULL);
 	if (IS_ERR(r_ino)) {
 		res = ERR_CAST(r_ino);
@@ -392,6 +393,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 out_free_name:
 	kfree(read_name);
 out:
+	nfs_free_fattr(fattr);
 	return res;
 out_stateowner:
 	nfs4_put_state_owner(sp);
-- 
2.35.1



