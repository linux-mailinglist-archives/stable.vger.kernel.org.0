Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A95637816E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhEJK0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231365AbhEJK0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7381461075;
        Mon, 10 May 2021 10:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642299;
        bh=lsQtnvg8mSO16p3n5+v4dArulbab2cr2n0yfB01NNzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTaY9kDQCoKhR3Lnqm50u1zVooNXPx9tKF7sUZkRvVSGHqLlqM7L7K4nMbBagoWpf
         b48mFtrZ62r+7h3+v8zhKE73Ha1RTL/ctjpyrkUriQCEa/MKD+42V2ej9xwGU1C7+6
         lTEbuIDbG2AUb7V6FyL6DScC9HiZkvhyL6WY9s5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.4 011/184] erofs: add unsupported inode i_format check
Date:   Mon, 10 May 2021 12:18:25 +0200
Message-Id: <20210510101950.580070203@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit 24a806d849c0b0c1d0cd6a6b93ba4ae4c0ec9f08 upstream.

If any unknown i_format fields are set (may be of some new incompat
inode features), mark such inode as unsupported.

Just in case of any new incompat i_format fields added in the future.

Link: https://lore.kernel.org/r/20210329003614.6583-1-hsiangkao@aol.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/erofs_fs.h |    3 +++
 fs/erofs/inode.c    |    7 +++++++
 2 files changed, 10 insertions(+)

--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -74,6 +74,9 @@ static inline bool erofs_inode_is_data_c
 #define EROFS_I_VERSION_BIT             0
 #define EROFS_I_DATALAYOUT_BIT          1
 
+#define EROFS_I_ALL	\
+	((1 << (EROFS_I_DATALAYOUT_BIT + EROFS_I_DATALAYOUT_BITS)) - 1)
+
 /* 32-byte reduced form of an ondisk inode */
 struct erofs_inode_compact {
 	__le16 i_format;	/* inode format hints */
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -44,6 +44,13 @@ static struct page *erofs_read_inode(str
 	dic = page_address(page) + *ofs;
 	ifmt = le16_to_cpu(dic->i_format);
 
+	if (ifmt & ~EROFS_I_ALL) {
+		erofs_err(inode->i_sb, "unsupported i_format %u of nid %llu",
+			  ifmt, vi->nid);
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	vi->datalayout = erofs_inode_datalayout(ifmt);
 	if (vi->datalayout >= EROFS_INODE_DATALAYOUT_MAX) {
 		erofs_err(inode->i_sb, "unsupported datalayout %u of nid %llu",


