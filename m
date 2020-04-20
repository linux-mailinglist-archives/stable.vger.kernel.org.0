Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9B1B0ACD
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgDTMsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgDTMse (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6667F2072B;
        Mon, 20 Apr 2020 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386913;
        bh=ENj6Qt52KrnVwLM66JGBO+2QFyAr22rkd+rd3OdPeVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGB+clyx4p79u6Lj6O9ONhjiqFGqbdXM7gkIpvw/uakwbP7biQro9I4lEKOtyWdLO
         eFdq7DJJu4FarEjv3x3z7OHYpf4H3Bk6ukz0FlNq19onF/JZrJK0cw7eCFVST1GndY
         bshHcy4Nq8ezfbN2rmfISJuBz94naL+cLH+qg96A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 09/40] ovl: fix value of i_ino for lower hardlink corner case
Date:   Mon, 20 Apr 2020 14:39:19 +0200
Message-Id: <20200420121454.159987874@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 300b124fcf6ad2cd99a7b721e0f096785e0a3134 upstream.

Commit 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more
cases"), relaxed the condition nfs_export=on in order to set the value of
i_ino to xino map of real ino.

Specifically, it also relaxed the pre-condition that index=on for
consistent i_ino. This opened the corner case of lower hardlink in
ovl_get_inode(), which calls ovl_fill_inode() with ino=0 and then
ovl_init_inode() is called to set i_ino to lower real ino without the xino
mapping.

Pass the correct values of ino;fsid in this case to ovl_fill_inode(), so it
can initialize i_ino correctly.

Fixes: 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more ...")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -884,7 +884,7 @@ struct inode *ovl_get_inode(struct super
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
-	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
+	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
@@ -934,6 +934,8 @@ struct inode *ovl_get_inode(struct super
 			err = -ENOMEM;
 			goto out_err;
 		}
+		ino = realinode->i_ino;
+		fsid = lowerpath->layer->fsid;
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);


