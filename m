Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4090D19B10B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbgDAQbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388318AbgDAQba (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA6152063A;
        Wed,  1 Apr 2020 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758690;
        bh=VsRh+mYVWjw3vw5igl7CNXGZG/GfmVCNJmJHfY/fTPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x768Jh3xL9+lCVSDWisBdriW/RhABiFxOnaUNZw3fu1JNT7hAH9QmwEmnxRk8i2Pm
         Cb3vIgikpDcaJfSCUH9o1eCAbGrn8tBzobx8AZ0uhfNU/yIiqNzw+gQC7nB/E+qE9F
         +rfEFGk3WzvvzHuult0wrrYY3rT0Dc3CdMk3qNuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 45/91] IB/ipoib: Do not warn if IPoIB debugfs doesnt exist
Date:   Wed,  1 Apr 2020 18:17:41 +0200
Message-Id: <20200401161529.019824784@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit 14fa91e0fef8e4d6feb8b1fa2a807828e0abe815 ]

netdev_wait_allrefs() could rebroadcast NETDEV_UNREGISTER event
multiple times until all refs are gone, which will result in calling
ipoib_delete_debug_files multiple times and printing a warning.

Remove the WARN_ONCE since checks of NULL pointers before calling
debugfs_remove are not needed.

Fixes: 771a52584096 ("IB/IPoIB: ibX: failed to create mcg debug file")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_fs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 09396bd7b02d2..63be3bcdc0e38 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -281,8 +281,6 @@ void ipoib_delete_debug_files(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
-	WARN_ONCE(!priv->mcg_dentry, "null mcg debug file\n");
-	WARN_ONCE(!priv->path_dentry, "null path debug file\n");
 	debugfs_remove(priv->mcg_dentry);
 	debugfs_remove(priv->path_dentry);
 	priv->mcg_dentry = priv->path_dentry = NULL;
-- 
2.20.1



