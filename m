Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A055198E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbiFTNAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243348AbiFTM5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D440A1ADAC;
        Mon, 20 Jun 2022 05:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE461614E8;
        Mon, 20 Jun 2022 12:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5483C3411B;
        Mon, 20 Jun 2022 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729726;
        bh=xKJgGnAp0JtvzVTO3ZMiIPxvPcxB/Pl0bxgrqj+nqCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6VnUSlQF925hJW1keRQYnpdDpFYCrHzVy7lD7dhJTlX2KUnzGTVNfA+UzOVUOfnh
         8PUo1fKp4LZroqr0Z44OAkexaIa/B6/7H4B8l+I5ZDDc+/3WV9bISw46EBLaDaPgTI
         O1CG9ZkX02Gx1EVrxFSHSnQfXIfrg8688oQg80EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 055/141] pNFS: Avoid a live lock condition in pnfs_update_layout()
Date:   Mon, 20 Jun 2022 14:49:53 +0200
Message-Id: <20220620124731.162638823@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 880265c77ac415090090d1fe72a188fee71cb458 ]

If we're about to send the first layoutget for an empty layout, we want
to make sure that we drain out the existing pending layoutget calls
first. The reason is that these layouts may have been already implicitly
returned to the server by a recall to which the client gave a
NFS4ERR_NOMATCHING_LAYOUT response.

The problem is that wait_var_event_killable() could in principle see the
plh_outstanding count go back to '1' when the first process to wake up
starts sending a new layoutget. If it fails to get a layout, then this
loop can continue ad infinitum...

Fixes: 0b77f97a7e42 ("NFSv4/pnfs: Fix layoutget behaviour after invalidation")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c |  1 +
 fs/nfs/pnfs.c          | 15 +++++++++------
 fs/nfs/pnfs.h          |  1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index c8520284dda7..c1eda73254e1 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -288,6 +288,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 		rv = NFS4_OK;
 		break;
 	case -ENOENT:
+		set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 		/* Embrace your forgetfulness! */
 		rv = NFS4ERR_NOMATCHING_LAYOUT;
 
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 4609e641710e..41a9b6b58fb9 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -469,6 +469,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
 	pnfs_free_returned_lsegs(lo, lseg_list, &range, 0);
+	set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 	if (test_bit(NFS_LAYOUT_RETURN, &lo->plh_flags) &&
 	    !test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		pnfs_clear_layoutreturn_waitbit(lo);
@@ -1917,8 +1918,9 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
 
 static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
 {
-	if (atomic_dec_and_test(&lo->plh_outstanding))
-		wake_up_var(&lo->plh_outstanding);
+	if (atomic_dec_and_test(&lo->plh_outstanding) &&
+	    test_and_clear_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags))
+		wake_up_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN);
 }
 
 static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
@@ -2025,11 +2027,11 @@ pnfs_update_layout(struct inode *ino,
 	 * If the layout segment list is empty, but there are outstanding
 	 * layoutget calls, then they might be subject to a layoutrecall.
 	 */
-	if ((list_empty(&lo->plh_segs) || !pnfs_layout_is_valid(lo)) &&
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
 	    atomic_read(&lo->plh_outstanding) != 0) {
 		spin_unlock(&ino->i_lock);
-		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
-					!atomic_read(&lo->plh_outstanding)));
+		lseg = ERR_PTR(wait_on_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN,
+					   TASK_KILLABLE));
 		if (IS_ERR(lseg))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);
@@ -2413,7 +2415,8 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	}
 
-	if (!pnfs_layout_is_valid(lo) && !pnfs_is_first_layoutget(lo))
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
+	    !pnfs_is_first_layoutget(lo))
 		goto out_forget;
 
 	if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 07f11489e4e9..f331f067691b 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -105,6 +105,7 @@ enum {
 	NFS_LAYOUT_FIRST_LAYOUTGET,	/* Serialize first layoutget */
 	NFS_LAYOUT_INODE_FREEING,	/* The inode is being freed */
 	NFS_LAYOUT_HASHED,		/* The layout visible */
+	NFS_LAYOUT_DRAIN,
 };
 
 enum layoutdriver_policy_flags {
-- 
2.35.1



