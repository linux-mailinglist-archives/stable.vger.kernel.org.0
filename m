Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FA2428EC4
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhJKNvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237358AbhJKNvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C82961040;
        Mon, 11 Oct 2021 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960131;
        bh=BOTMTMdEQlb87siItMAjDmzfal5VegK3bKX4bR25pio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyBuy3mKorna0FKKs2ECj2T3RuMZmBqg3Z6shhEC88sB1j4KY17kKL1YP5+JSFZgm
         7ZeP4kHCQk0tHscxT1THs8dvSnSWDH5apUczfhHFXhwdzMnC/ulE9+da5EtbsAkQ+R
         bHdBXAH9qrWk/5QVcvbOIxTRyq4Vz6ClV6ajIhBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Liang <zhengliang6@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 07/52] ovl: fix missing negative dentry check in ovl_rename()
Date:   Mon, 11 Oct 2021 15:45:36 +0200
Message-Id: <20211011134503.972537152@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Liang <zhengliang6@huawei.com>

commit a295aef603e109a47af355477326bd41151765b6 upstream.

The following reproducer

  mkdir lower upper work merge
  touch lower/old
  touch lower/new
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
  rm merge/new
  mv merge/old merge/new & unlink upper/new

may result in this race:

PROCESS A:
  rename("merge/old", "merge/new");
  overwrite=true,ovl_lower_positive(old)=true,
  ovl_dentry_is_whiteout(new)=true -> flags |= RENAME_EXCHANGE

PROCESS B:
  unlink("upper/new");

PROCESS A:
  lookup newdentry in new_upperdir
  call vfs_rename() with negative newdentry and RENAME_EXCHANGE

Fix by adding the missing check for negative newdentry.

Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1162,9 +1162,13 @@ static int ovl_rename(struct inode *oldd
 				goto out_dput;
 		}
 	} else {
-		if (!d_is_negative(newdentry) &&
-		    (!new_opaque || !ovl_is_whiteout(newdentry)))
-			goto out_dput;
+		if (!d_is_negative(newdentry)) {
+			if (!new_opaque || !ovl_is_whiteout(newdentry))
+				goto out_dput;
+		} else {
+			if (flags & RENAME_EXCHANGE)
+				goto out_dput;
+		}
 	}
 
 	if (olddentry == trap)


