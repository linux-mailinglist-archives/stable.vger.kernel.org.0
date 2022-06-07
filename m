Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B2540E54
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353488AbiFGSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354518AbiFGSrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813DF7B9DE;
        Tue,  7 Jun 2022 11:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337A9B82349;
        Tue,  7 Jun 2022 18:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDEAC34119;
        Tue,  7 Jun 2022 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624898;
        bh=W+7OA4ML0uSPtiBU2Ktbpw1dToWXDBw/qv2qjE5Ek+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKVw6IqVD78fTjorHkFu7wogy2EXuue7PRfAPfxWcwX/MtVqBFwKWheupIsHjFF/K
         1UcpTQa5jv602u7nEuiD2CE6URhsDxEpceY7pNZZtL1PUByQxFHDSm1tciNLemZN+y
         WC1jIULwzRd6gJCNsON2KOt1CbilAdvn9fNAZuOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 494/667] NFS: fsync() should report filesystem errors over EINTR/ERESTARTSYS
Date:   Tue,  7 Jun 2022 19:02:39 +0200
Message-Id: <20220607164949.514509369@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9641d9bc9b75f11f70646f5c6ee9f5f519a1012e ]

If the commit to disk is interrupted, we should still first check for
filesystem errors so that we can report them in preference to the error
due to the signal.

Fixes: 2197e9b06c22 ("NFS: Fix up fsync() when the server rebooted")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 42a16993913a..018d29a79e73 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -208,15 +208,16 @@ static int
 nfs_file_fsync_commit(struct file *file, int datasync)
 {
 	struct inode *inode = file_inode(file);
-	int ret;
+	int ret, ret2;
 
 	dprintk("NFS: fsync file(%pD2) datasync %d\n", file, datasync);
 
 	nfs_inc_stats(inode, NFSIOS_VFSFSYNC);
 	ret = nfs_commit_inode(inode, FLUSH_SYNC);
-	if (ret < 0)
-		return ret;
-	return file_check_and_advance_wb_err(file);
+	ret2 = file_check_and_advance_wb_err(file);
+	if (ret2 < 0)
+		return ret2;
+	return ret;
 }
 
 int
-- 
2.35.1



