Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FAE439F42
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhJYTTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234570AbhJYTSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E41B600D3;
        Mon, 25 Oct 2021 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189382;
        bh=HQ2gS4RXwqhHL1WI4Fc5nD1/tiAg5Hlzeqp0CsHIbgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL4HK+tDCiGQP9alh+qbBV4oa7xW4yW+V3ha1wQK1Rz4CMq1bF5tjoYQW0omPWt8L
         O74O6HT4t89V8vVd2TCX+pMIos5l0S2mqYsinRmunk8bpH9r7h0Ebq8WgQY+EIQi7F
         QjCXvWj0jWYE9FLbbfb5EkxydR8y9W1UfkPBHlxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Liang <zhengliang6@huawei.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        "Masami Ichikawa(CIP)" <masami.ichikawa@cybertrust.co.jp>
Subject: [PATCH 4.4 33/44] ovl: fix missing negative dentry check in ovl_rename()
Date:   Mon, 25 Oct 2021 21:14:14 +0200
Message-Id: <20211025190935.428177228@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
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
Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>

---
 fs/overlayfs/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -824,9 +824,13 @@ static int ovl_rename2(struct inode *old
 		}
 	} else {
 		new_create = true;
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


