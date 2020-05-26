Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACC1E2AF7
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbgEZTAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390758AbgEZTAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EA620849;
        Tue, 26 May 2020 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519633;
        bh=sEH7FlcbtULD/jnI/XwLJzHyZ9OSJdBrQc3iYDd0vrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpNdns1dkuoV4ftudsmSA3u7kHIFXw6swCmtet0LkR1YAHnluNzbNXm0meAcNITYI
         plMPnhtZbTAnDA4pDHgcKQ0ykobj3niR6QVh/1FIXVgBQI7+DB98C3H/226x4IgVky
         mhc83LoOaHp4J41SwieHitbiRDM0rZMGTqV21L/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/59] configfs: fix config_item refcnt leak in configfs_rmdir()
Date:   Tue, 26 May 2020 20:53:01 +0200
Message-Id: <20200526183913.423965027@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 8aebfffacfa379ba400da573a5bf9e49634e38cb ]

configfs_rmdir() invokes configfs_get_config_item(), which returns a
reference of the specified config_item object to "parent_item" with
increased refcnt.

When configfs_rmdir() returns, local variable "parent_item" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
configfs_rmdir(). When down_write_killable() fails, the function forgets
to decrease the refcnt increased by configfs_get_config_item(), causing
a refcnt leak.

Fix this issue by calling config_item_put() when down_write_killable()
fails.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index c2ef617d2f97..c875f246cb0e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1537,6 +1537,7 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		spin_lock(&configfs_dirent_lock);
 		configfs_detach_rollback(dentry);
 		spin_unlock(&configfs_dirent_lock);
+		config_item_put(parent_item);
 		return -EINTR;
 	}
 	frag->frag_dead = true;
-- 
2.25.1



