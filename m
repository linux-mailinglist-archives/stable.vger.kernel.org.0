Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCD7656EC8
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiL0UeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiL0Udb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0F3DED4;
        Tue, 27 Dec 2022 12:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70ACF6123B;
        Tue, 27 Dec 2022 20:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304AC433F0;
        Tue, 27 Dec 2022 20:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173209;
        bh=Nk3jaQ6ju/z4RcNdUSiRE2Pmybk1zYp+x8kUZcuNn3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmFZfxQa7nz8xqEZxT0BNYsdy3UoVZx5c3/Kn+ryxUwCkua/zvBQzitiX10KXeiCM
         kv0IikwZ11a7NDdoV0NCWzlZasJ1u+s3HLbCmnrREhDN+mXib2mcEqZKEZ8SjpEVRF
         sfA2wEWhM9+VEkIZOWMNEWv80jD/Xuqk7fWvQfDs4Vy1wWAxf9HHEFKYvTiGV8Xh1B
         Y96B16L72b1fKPo4MwJZyGN1CG0PwRbChe2gMe1unQ9eZPHetu8iKq/MdxWftxUDfd
         QSldCsoF+B76jhBqogLGcBnzOV/T8kjQlBl1ZfQvJjZdBw9LmEqLg7mARliuJ1wIyL
         8CsKc63bV5vvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dai Ngo <dai.ngo@oracle.com>, Xingyuan Mo <hdthky0@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/28] NFSD: fix use-after-free in __nfs42_ssc_open()
Date:   Tue, 27 Dec 2022 15:32:45 -0500
Message-Id: <20221227203249.1213526-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 75333d48f92256a0dec91dbf07835e804fc411c0 ]

Problem caused by source's vfsmount being unmounted but remains
on the delayed unmount list. This happens when nfs42_ssc_open()
return errors.

Fixed by removing nfsd4_interssc_connect(), leave the vfsmount
for the laundromat to unmount when idle time expires.

We don't need to call nfs_do_sb_deactive when nfs42_ssc_open
return errors since the file was not opened so nfs_server->active
was not incremented. Same as in nfsd4_copy, if we fail to
launch nfsd4_do_async_copy thread then there's no need to
call nfs_do_sb_deactive

Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8beb2bc4c328..b79ee65ae016 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1463,13 +1463,6 @@ nfsd4_interssc_connect(struct nl4_server *nss, struct svc_rqst *rqstp,
 	return status;
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-	nfs_do_sb_deactive(ss_mnt->mnt_sb);
-	mntput(ss_mnt);
-}
-
 /*
  * Verify COPY destination stateid.
  *
@@ -1572,11 +1565,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 {
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-}
-
 static struct file *nfs42_ssc_open(struct vfsmount *ss_mnt,
 				   struct nfs_fh *src_fh,
 				   nfs4_stateid *stateid)
@@ -1771,7 +1759,7 @@ static int nfsd4_do_async_copy(void *data)
 			default:
 				nfserr = nfserr_offload_denied;
 			}
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 		nfserr = nfsd4_do_copy(copy, filp, copy->nf_dst->nf_file,
@@ -1852,8 +1840,10 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	if (nfsd4_ssc_is_inter(copy))
-		nfsd4_interssc_disconnect(copy->ss_mnt);
+	/*
+	 * source's vfsmount of inter-copy will be unmounted
+	 * by the laundromat
+	 */
 	goto out;
 }
 
-- 
2.35.1

