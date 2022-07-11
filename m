Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63256FD3E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiGKJxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiGKJwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:52:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B553AB39;
        Mon, 11 Jul 2022 02:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C11B80D2C;
        Mon, 11 Jul 2022 09:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29723C34115;
        Mon, 11 Jul 2022 09:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531518;
        bh=6yGShLJBClWDowMoevtSmpngGA0EyC9sGK0/MTq4gsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXE6WviASoN1Luj5MaXvtIv6N5f0uZWcrkLi7yv9iCsvoWso0d/j9axgTgSK93gVJ
         Eb/ePLgETUpeIvYnN9FXi1Phw0QZYFT9ZRm82GFZiYrJYwoXiq4KsKOGq5tq7cWzQV
         u4hl2Th8V7g8Xek8UPbUVAjKAMNNjLOisDX9VgP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/230] NFSD: De-duplicate net_generic(nf->nf_net, nfsd_net_id)
Date:   Mon, 11 Jul 2022 11:05:50 +0200
Message-Id: <20220711090606.738860895@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2c445a0e72cb1fbfbdb7f9473c53556ee27c1d90 ]

Since this pointer is used repeatedly, move it to a stack variable.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5f62fa0963ce..c8e3f81d110e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1121,6 +1121,7 @@ __be32
 nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
                loff_t offset, unsigned long count, __be32 *verf)
 {
+	struct nfsd_net		*nn;
 	struct nfsd_file	*nf;
 	loff_t			end = LLONG_MAX;
 	__be32			err = nfserr_inval;
@@ -1137,6 +1138,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (err)
 		goto out;
+	nn = net_generic(nf->nf_net, nfsd_net_id);
 	if (EX_ISSYNC(fhp->fh_export)) {
 		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
 		int err2;
@@ -1144,8 +1146,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
 		switch (err2) {
 		case 0:
-			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-						nfsd_net_id));
+			nfsd_copy_boot_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
 			err = nfserrno(err2);
@@ -1154,13 +1155,11 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
-						 nfsd_net_id));
+			nfsd_reset_boot_verifier(nn);
 			err = nfserrno(err2);
 		}
 	} else
-		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-					nfsd_net_id));
+		nfsd_copy_boot_verifier(verf, nn);
 
 	nfsd_file_put(nf);
 out:
-- 
2.35.1



