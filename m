Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4033328CF1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbhCATCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234879AbhCAS4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FCBA65045;
        Mon,  1 Mar 2021 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617148;
        bh=EP4oZj3kW/2Ml7JpJzN8pbUf8lXxjfZ55o/PU8s51sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R58ojUX26KfArtiw+zBIV3UyUWQcfmGh5jIquRYk+6SYUmCXLgys2+fo8Rlw+1rmL
         FdWE9mmg0nWF3RjWERPJz37ZMLLHKCFrhQIb/Pu7lQuAssP1XagvliISI5R87kVoPj
         mYAjObFmo13ZHWAu0zbrz3QCuhyimz8QN9RER1tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 218/247] fs/affs: release old buffer head on error path
Date:   Mon,  1 Mar 2021 17:13:58 +0100
Message-Id: <20210301161042.346872751@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 70779b897395b330ba5a47bed84f94178da599f9 upstream.

The reference count of the old buffer head should be decremented on path
that fails to get the new buffer head.

Fixes: 6b4657667ba0 ("fs/affs: add rename exchange")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/affs/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -460,8 +460,10 @@ affs_xrename(struct inode *old_dir, stru
 		return -EIO;
 
 	bh_new = affs_bread(sb, d_inode(new_dentry)->i_ino);
-	if (!bh_new)
+	if (!bh_new) {
+		affs_brelse(bh_old);
 		return -EIO;
+	}
 
 	/* Remove old header from its parent directory. */
 	affs_lock_dir(old_dir);


