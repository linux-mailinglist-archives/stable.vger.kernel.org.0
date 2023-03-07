Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA56AEF6F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjCGSXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjCGSXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7FA1B2FB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 551BE61520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D627C433EF;
        Tue,  7 Mar 2023 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213079;
        bh=RQPPLFOfBcYl10wJzXhaB3Jx8Fb2K4LF6PhfqkcMGeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojRZ357kVlbVkPS2AtWY+AkeM/TYbmdD1yQqiXZUZIpxgNLlmWAX/1lyJsH8HMjYi
         ZBqTx5U7XFiD/LFrJgkJnTAwh9IOi0OqSIlX3mkf0PNaaWFwUTCE5Zn9bfUcorr6Lb
         Cvh1AgqMVjv8WTIGIb09Ij/MV6ffQbaNTh8X1PnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dai Ngo <dai.ngo@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/885] NFSD: fix leaked reference count of nfsd4_ssc_umount_item
Date:   Tue,  7 Mar 2023 17:55:08 +0100
Message-Id: <20230307170018.567950461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 34e8f9ec4c9ac235f917747b23a200a5e0ec857b ]

The reference count of nfsd4_ssc_umount_item is not decremented
on error conditions. This prevents the laundromat from unmounting
the vfsmount of the source file.

This patch decrements the reference count of nfsd4_ssc_umount_item
on error.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 92b63e51d28da..32652b5e6eff3 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1827,13 +1827,17 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 out:
 	return status;
 out_err:
+	if (nfsd4_ssc_is_inter(copy)) {
+		/*
+		 * Source's vfsmount of inter-copy will be unmounted
+		 * by the laundromat. Use copy instead of async_copy
+		 * since async_copy->ss_nsui might not be set yet.
+		 */
+		refcount_dec(&copy->ss_nsui->nsui_refcnt);
+	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	/*
-	 * source's vfsmount of inter-copy will be unmounted
-	 * by the laundromat
-	 */
 	goto out;
 }
 
-- 
2.39.2



