Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A396A3743
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjB0CID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjB0CHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:07:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2942BBA4;
        Sun, 26 Feb 2023 18:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83135B80CB7;
        Mon, 27 Feb 2023 02:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7E4C4339E;
        Mon, 27 Feb 2023 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463494;
        bh=7LocvD7brZ2oxs/4IkzlplVA36ObR8Szg7EKJssTyb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuvGQcLmrjc/0/qMK6SDOh+Gz9R2FLY6sa66GUFug9I61UiT1vjRAUIEmXA0OVI2G
         n7dyuBKmpFNLCVGO29iHYbThyKKSp9YSSxDd8qtFBJElCWg8IO8kNzokNH3zdlAXew
         ckaHfIUdZ5e+u+XeyRnQQ4psVVjwO8heszsgqYwFJnmPPZY5D4vqER17x9UMMJMaes
         q2EHCGgwlRqHS68Zn6qZPubSa58V9Quoy29s9gWYg3TI4HHo2LCWSVmBOy10aXhL4y
         axu24M4XrYvvdxnCmXG3ijJhWFSPJ4Lngdz/AyVuM1wAQtfwB0gK+YSx2XWM7GjSfE
         zUB0zwDtFXHOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Boyang Xue <bxue@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 59/60] nfsd: don't hand out delegation on setuid files being opened for write
Date:   Sun, 26 Feb 2023 21:00:44 -0500
Message-Id: <20230227020045.1045105-59-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 826b67e6376c2a788e3a62c4860dcd79500a27d5 ]

We had a bug report that xfstest generic/355 was failing on NFSv4.0.
This test sets various combinations of setuid/setgid modes and tests
whether DIO writes will cause them to be stripped.

What I found was that the server did properly strip those bits, but
the client didn't notice because it held a delegation that was not
recalled. The recall didn't occur because the client itself was the
one generating the activity and we avoid recalls in that case.

Clearing setuid bits is an "implicit" activity. The client didn't
specifically request that we do that, so we need the server to issue a
CB_RECALL, or avoid the situation entirely by not issuing a delegation.

The easiest fix here is to simply not give out a delegation if the file
is being opened for write, and the mode has the setuid and/or setgid bit
set. Note that there is a potential race between the mode and lease
being set, so we test for this condition both before and after setting
the lease.

This patch fixes generic/355, generic/683 and generic/684 for me. (Note
that 355 fails only on v4.0, and 683 and 684 require NFSv4.2 to run and
fail).

Reported-by: Boyang Xue <bxue@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c69f27d3adb79..b6c9d2bfb12b7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5438,6 +5438,23 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	return 0;
 }
 
+/*
+ * We avoid breaking delegations held by a client due to its own activity, but
+ * clearing setuid/setgid bits on a write is an implicit activity and the client
+ * may not notice and continue using the old mode. Avoid giving out a delegation
+ * on setuid/setgid files when the client is requesting an open for write.
+ */
+static int
+nfsd4_verify_setuid_write(struct nfsd4_open *open, struct nfsd_file *nf)
+{
+	struct inode *inode = file_inode(nf->nf_file);
+
+	if ((open->op_share_access & NFS4_SHARE_ACCESS_WRITE) &&
+	    (inode->i_mode & (S_ISUID|S_ISGID)))
+		return -EAGAIN;
+	return 0;
+}
+
 static struct nfs4_delegation *
 nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 		    struct svc_fh *parent)
@@ -5471,6 +5488,8 @@ nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	spin_lock(&fp->fi_lock);
 	if (nfs4_delegation_exists(clp, fp))
 		status = -EAGAIN;
+	else if (nfsd4_verify_setuid_write(open, nf))
+		status = -EAGAIN;
 	else if (!fp->fi_deleg_file) {
 		fp->fi_deleg_file = nf;
 		/* increment early to prevent fi_deleg_file from being
@@ -5511,6 +5530,14 @@ nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 	if (status)
 		goto out_unlock;
 
+	/*
+	 * Now that the deleg is set, check again to ensure that nothing
+	 * raced in and changed the mode while we weren't lookng.
+	 */
+	status = nfsd4_verify_setuid_write(open, fp->fi_deleg_file);
+	if (status)
+		goto out_unlock;
+
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
 	if (fp->fi_had_conflict)
-- 
2.39.0

