Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7E11AF64
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbfLKPNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfLKPNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC3024681;
        Wed, 11 Dec 2019 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077195;
        bh=9xd/VABcza9uEglJOSz/DEebvYrkbh5MIhe0PXjV2sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSs4kW/BX8LMGxV0ky/u9piWs5XtptCTI+RjIB5eCLYEdu2hChTudNalKrtoGZTHC
         Z+ZZ/S8YPhbvSGd08w+XFU0V58jO6r8l21+WG2uJ2ivw3kVFkM2NUfq3YgSucNSvrs
         P8f/m4OCOi1BdjfAW6Vq3+iVnD4sLjKqtrcL+q8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.3 045/105] fuse: verify nlink
Date:   Wed, 11 Dec 2019 16:05:34 +0100
Message-Id: <20191211150239.290851608@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit c634da718db9b2fac201df2ae1b1b095344ce5eb upstream.

When adding a new hard link, make sure that i_nlink doesn't overflow.

Fixes: ac45d61357e8 ("fuse: fix nlink after unlink")
Cc: <stable@vger.kernel.org> # v3.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -814,7 +814,8 @@ static int fuse_link(struct dentry *entr
 
 		spin_lock(&fi->lock);
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
-		inc_nlink(inode);
+		if (likely(inode->i_nlink < UINT_MAX))
+			inc_nlink(inode);
 		spin_unlock(&fi->lock);
 		fuse_invalidate_attr(inode);
 		fuse_update_ctime(inode);


