Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6B04D7BE
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfFTSJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbfFTSJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:09:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DDB2168B;
        Thu, 20 Jun 2019 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054186;
        bh=hJIVkZmUXKRDiFky2sa8B26jbrjDMH3oCqC5/EdVNPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDyWh2dzm2OgYCwwSi+fBCFsi9JH+fWjbzfkoN+u83/3OVcHQuRBUkH2SInag900u
         2ZBJX0TCRYYCSE1o/0jiOFnwCj3Dn4L3Uq2Fx5m+P7Z4AX57GETh1TNfO79jRSkWIh
         xAv51W7xGp4L8N7qYgr1Ehmcq0Qy9M5Lvz574gmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/45] configfs: Fix use-after-free when accessing sd->s_dentry
Date:   Thu, 20 Jun 2019 19:57:29 +0200
Message-Id: <20190620174338.663341683@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f6122ed2a4f9c9c1c073ddf6308d1b2ac10e0781 ]

In the vfs_statx() context, during path lookup, the dentry gets
added to sd->s_dentry via configfs_attach_attr(). In the end,
vfs_statx() kills the dentry by calling path_put(), which invokes
configfs_d_iput(). Ideally, this dentry must be removed from
sd->s_dentry but it doesn't if the sd->s_count >= 3. As a result,
sd->s_dentry is holding reference to a stale dentry pointer whose
memory is already freed up. This results in use-after-free issue,
when this stale sd->s_dentry is accessed later in
configfs_readdir() path.

This issue can be easily reproduced, by running the LTP test case -
sh fs_racer_file_list.sh /config
(https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/fs/racer/fs_racer_file_list.sh)

Fixes: 76ae281f6307 ('configfs: fix race between dentry put and lookup')
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index d7955dc56737..a1985a9ad2d6 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -58,15 +58,13 @@ static void configfs_d_iput(struct dentry * dentry,
 	if (sd) {
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		/* Coordinate with configfs_attach_attr where will increase
-		 * sd->s_count and update sd->s_dentry to new allocated one.
-		 * Only set sd->dentry to null when this dentry is the only
-		 * sd owner.
-		 * If not do so, configfs_d_iput may run just after
-		 * configfs_attach_attr and set sd->s_dentry to null
-		 * even it's still in use.
+		/*
+		 * Set sd->s_dentry to null only when this dentry is the one
+		 * that is going to be killed.  Otherwise configfs_d_iput may
+		 * run just after configfs_attach_attr and set sd->s_dentry to
+		 * NULL even it's still in use.
 		 */
-		if (atomic_read(&sd->s_count) <= 2)
+		if (sd->s_dentry == dentry)
 			sd->s_dentry = NULL;
 
 		spin_unlock(&configfs_dirent_lock);
-- 
2.20.1



