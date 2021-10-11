Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD6E42913B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243983AbhJKOQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242256AbhJKOOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C40916134F;
        Mon, 11 Oct 2021 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961091;
        bh=8LN5JaR3NNu+w4nvoNIV28oJquM2WaOUpFHljkennYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQvOcM+mRN8okFcQkTjxyHpEMElKqm1HD5ypyOMFVdBVB/vhkfdkUsC8io2YqPREQ
         QEZ86y88Dx6cVd4CnXWNKiKPxxDN5oWzo//UtgUhpqdVAqMreYa4wUJIMtgFOWPKGu
         3qcwKt2AcPT46xvmh/bmKwOzjkz666zSN1wO9OEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Liang <zhengliang6@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 05/28] ovl: fix missing negative dentry check in ovl_rename()
Date:   Mon, 11 Oct 2021 15:46:55 +0200
Message-Id: <20211011134640.886065565@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
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
@@ -1166,9 +1166,13 @@ static int ovl_rename(struct inode *oldd
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


