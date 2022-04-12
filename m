Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF02F4FD95D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351987AbiDLH2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354327AbiDLHRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ABD4BFC9;
        Mon, 11 Apr 2022 23:58:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 617EDB81B4E;
        Tue, 12 Apr 2022 06:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8501C385A6;
        Tue, 12 Apr 2022 06:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746731;
        bh=omJPdwzim7+gF+epFl1+yrl30omXgQ1LDk469zs4QD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9XUCGv/CPGmFVu/9jz2L9kF8T2Kdzyi3IpZf/zc9kNIdvCgbj72t0VFMEQIUD3tB
         50H2uQnrlBu2TJmsfG4n4nOW8GJ9y2ixYhpWHf9s/0a6/695e4kTkNVpLwzKF9IV3D
         gMEXYUKjIdkiiyhj44qhRziI9tG7azp/K5atTbpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 109/285] ceph: fix inode reference leakage in ceph_get_snapdir()
Date:   Tue, 12 Apr 2022 08:29:26 +0200
Message-Id: <20220412062946.810956396@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 322794d3355c33adcc4feace0045d85a8e4ed813 ]

The ceph_get_inode() will search for or insert a new inode into the
hash for the given vino, and return a reference to it. If new is
non-NULL, its reference is consumed.

We should release the reference when in error handing cases.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e3322fcb2e8d..6d87991cf67e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -87,13 +87,13 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	if (!S_ISDIR(parent->i_mode)) {
 		pr_warn_once("bad snapdir parent type (mode=0%o)\n",
 			     parent->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
 		pr_warn_once("bad snapdir inode type (mode=0%o)\n",
 			     inode->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	inode->i_mode = parent->i_mode;
@@ -113,6 +113,12 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	}
 
 	return inode;
+err:
+	if ((inode->i_state & I_NEW))
+		discard_new_inode(inode);
+	else
+		iput(inode);
+	return ERR_PTR(-ENOTDIR);
 }
 
 const struct inode_operations ceph_file_iops = {
-- 
2.35.1



