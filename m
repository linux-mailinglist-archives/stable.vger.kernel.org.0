Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2A1215FD
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731496AbfLPSZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbfLPSRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1167E206E0;
        Mon, 16 Dec 2019 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520259;
        bh=+acM6/3oFbKzz7oCcG64SWWaZNc21NPB0mvTRhzs49c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEMS+1nIz5tYwLvlpq3ubL+wujCqoLhRirpCwhzAxi4G60wfEcwTXoL+n/kKi3XgH
         q9whT+JvEKS84IBhbV/DlsRs8ugKUSS72tkeEDofDSYnpEpcKweOK96pMGWqBC7BEb
         Iu02YgYrK/7rCA8UjO3H62BtjkfSMSz5AORSQvUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 080/177] ovl: fix corner case of non-unique st_dev;st_ino
Date:   Mon, 16 Dec 2019 18:48:56 +0100
Message-Id: <20191216174836.969129558@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 9c6d8f13e9da10a26ad7f0a020ef86e8ef142835 upstream.

On non-samefs overlay without xino, non pure upper inodes should use a
pseudo_dev assigned to each unique lower fs and pure upper inodes use the
real upper st_dev.

It is fine for an overlay pure upper inode to use the same st_dev;st_ino
values as the real upper inode, because the content of those two different
filesystem objects is always the same.

In this case, however:
 - two filesystems, A and B
 - upper layer is on A
 - lower layer 1 is also on A
 - lower layer 2 is on B

Non pure upper overlay inode, whose origin is in layer 1 will have the same
st_dev;st_ino values as the real lower inode. This may result with a false
positive results of 'diff' between the real lower and copied up overlay
inode.

Fix this by using the upper st_dev;st_ino values in this case.  This breaks
the property of constant st_dev;st_ino across copy up of this case. This
breakage will be fixed by a later patch.

Fixes: 5148626b806a ("ovl: allocate anon bdev per unique lower fs")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/inode.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -200,8 +200,14 @@ int ovl_getattr(const struct path *path,
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
 			     (is_dir || lowerstat.nlink == 1))) {
-				stat->ino = lowerstat.ino;
 				lower_layer = ovl_layer_lower(dentry);
+				/*
+				 * Cannot use origin st_dev;st_ino because
+				 * origin inode content may differ from overlay
+				 * inode content.
+				 */
+				if (samefs || lower_layer->fsid)
+					stat->ino = lowerstat.ino;
 			}
 
 			/*


