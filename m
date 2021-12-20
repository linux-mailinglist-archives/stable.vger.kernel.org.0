Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA70947ADD0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhLTOzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbhLTOxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 537A0B80EED;
        Mon, 20 Dec 2021 14:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1F0C36AE8;
        Mon, 20 Dec 2021 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012011;
        bh=yAxLY43e/193cLD8NXZxPV2yxJ8/LbhH0tisFAANNGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKYrAMT1IhAteeeyxa1FVF6CqJiDFUA+r0bADQ77KuRm3+bIc2p4HhPEaUeREODPv
         aPy1rdsAGxfBZI4W/iBhLiINCrDjOCU+svMkdSdPoyIsX4L1cBLVIYW2htrd+T3sPI
         9K+BT8SIAhFKUzSYhQtY72w3YP3422wgfdF5l5hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/177] ceph: initialize pathlen variable in reconnect_caps_cb
Date:   Mon, 20 Dec 2021 15:33:19 +0100
Message-Id: <20211220143041.749475768@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
index d64413adc0fd2..e9409c460acd0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3772,7 +3772,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
 	char *path;
-	int pathlen, err;
+	int pathlen = 0, err;
 	u64 pathbase;
 	u64 snap_follows;
 
@@ -3792,7 +3792,6 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		}
 	} else {
 		path = NULL;
-		pathlen = 0;
 		pathbase = 0;
 	}
 
-- 
2.33.0



