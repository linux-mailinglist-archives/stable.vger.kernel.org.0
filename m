Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148804B47CD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbiBNJen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbiBNJed (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:34:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D2A184;
        Mon, 14 Feb 2022 01:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B519B80DC1;
        Mon, 14 Feb 2022 09:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEEAC340F1;
        Mon, 14 Feb 2022 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831143;
        bh=pvHjRwPYTp6QvDSbZ2cNvqcx31PEPKULayVnag4bn4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCZPLfD39r5I+5oDF7NWoxuNjwSWqM0k6tvCNT13Kp80CD5/URSm4cYFV6PVKLTUw
         hD07iorCThkI/d3ckatGcTAIhUb6QFdwWKe6Kebfo67TG7SJUrg2Vg0ZXDSub6utwv
         qppl9K6LU9nUx37VVsa+oUOk3VAxAV96PNM2RxNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/49] NFSv4 remove zero number of fs_locations entries error check
Date:   Mon, 14 Feb 2022 10:25:38 +0100
Message-Id: <20220214092448.708232403@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 90e12a3191040bd3854d3e236c35921e4e92a044 ]

Remove the check for the zero length fs_locations reply in the
xdr decoding, and instead check for that in the migration code.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 3 +++
 fs/nfs/nfs4xdr.c   | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b3086e99420c7..9c98547fcefcc 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2066,6 +2066,9 @@ static int nfs4_try_migration(struct nfs_server *server, struct rpc_cred *cred)
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 8a61dc21d3d68..56e48642c43eb 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3747,8 +3747,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 	if (unlikely(!p))
 		goto out_overflow;
 	n = be32_to_cpup(p);
-	if (n <= 0)
-		goto out_eio;
 	for (res->nlocations = 0; res->nlocations < n; res->nlocations++) {
 		u32 m;
 		struct nfs4_fs_location *loc;
-- 
2.34.1



