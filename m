Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D9A47AD25
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhLTOuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbhLTOrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D8946119C;
        Mon, 20 Dec 2021 14:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1821EC36AE7;
        Mon, 20 Dec 2021 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011652;
        bh=of4g4xbmSWLmDJmQfaSf6INV1XEbOTKozP5KPSB2Owg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8C88NntobkvoA4hQcTwm19moI2Bz9someyCR24CkP4y8olXayYDrBGsPkf25zw+1
         szYV1R3Jt62QIe14GPDTrokpBxuYUUtRrYjIpiKDzev/WTrc0GHR48battGd7hsgKj
         Cf15y4N2Rd3bu0GgtVM9HwagQWqbfWn5vLLr/bQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/99] ceph: initialize pathlen variable in reconnect_caps_cb
Date:   Mon, 20 Dec 2021 15:33:59 +0100
Message-Id: <20211220143030.227569446@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit ee2a095d3b24f300a5e11944d208801e928f108c ]

The smatch static checker warned about an uninitialized symbol usage in
this function, in the case where ceph_mdsc_build_path returns an error.

It turns out that that case is harmless, but it just looks sketchy.
Initialize the variable at declaration time, and remove the unneeded
setting of it later.

Fixes: a33f6432b3a6 ("ceph: encode inodes' parent/d_name in cap reconnect message")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 76e347a8cf088..981a915906314 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3696,7 +3696,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
 	char *path;
-	int pathlen, err;
+	int pathlen = 0, err;
 	u64 pathbase;
 	u64 snap_follows;
 
@@ -3716,7 +3716,6 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		}
 	} else {
 		path = NULL;
-		pathlen = 0;
 		pathbase = 0;
 	}
 
-- 
2.33.0



