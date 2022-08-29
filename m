Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545B5A48FF
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiH2LTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiH2LSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:18:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4606DAC2;
        Mon, 29 Aug 2022 04:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A8A611B5;
        Mon, 29 Aug 2022 11:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43443C433D6;
        Mon, 29 Aug 2022 11:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771002;
        bh=4FghYDHna6S5rhzo+Rl9VOc4RV5gF/FkMeafEW6AivU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5B613Zi9F+NnaJ537KBGzEsm8ZG8hvyefYTwaj0OdfNeXUF6ks3CQq/4RiFOK7x5
         tDUYUP1RQX7+ObEB+7ScILVO8t3EE6cihfCMSupoh/MISh8Kdk3dei/ot+LKgZ9MPT
         Ha8RjgjL7D/rRQRTxBgaBLlIlKE4+Tp3P5VOLjRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/136] NFS: Dont allocate nfs_fattr on the stack in __nfs42_ssc_open()
Date:   Mon, 29 Aug 2022 12:58:20 +0200
Message-Id: <20220829105805.943725596@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
index 4120e1cb3feef..61ee03c8bcd2d 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -319,7 +319,7 @@ static int read_name_gen = 1;
 static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		struct nfs_fh *src_fh, nfs4_stateid *stateid)
 {
-	struct nfs_fattr fattr;
+	struct nfs_fattr *fattr = nfs_alloc_fattr();
 	struct file *filep, *res;
 	struct nfs_server *server;
 	struct inode *r_ino = NULL;
@@ -330,9 +330,10 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 
 	server = NFS_SERVER(ss_mnt->mnt_root->d_inode);
 
-	nfs_fattr_init(&fattr);
+	if (!fattr)
+		return ERR_PTR(-ENOMEM);
 
-	status = nfs4_proc_getattr(server, src_fh, &fattr, NULL, NULL);
+	status = nfs4_proc_getattr(server, src_fh, fattr, NULL, NULL);
 	if (status < 0) {
 		res = ERR_PTR(status);
 		goto out;
@@ -345,7 +346,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 		goto out;
 	snprintf(read_name, len, SSC_READ_NAME_BODY, read_name_gen++);
 
-	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, &fattr,
+	r_ino = nfs_fhget(ss_mnt->mnt_root->d_inode->i_sb, src_fh, fattr,
 			NULL);
 	if (IS_ERR(r_ino)) {
 		res = ERR_CAST(r_ino);
@@ -390,6 +391,7 @@ static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
 out_free_name:
 	kfree(read_name);
 out:
+	nfs_free_fattr(fattr);
 	return res;
 out_stateowner:
 	nfs4_put_state_owner(sp);
-- 
2.35.1



