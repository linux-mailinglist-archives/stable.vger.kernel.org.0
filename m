Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B988638A214
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhETJhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhETJgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CACB6140B;
        Thu, 20 May 2021 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502986;
        bh=85t7FomwfIe6tRFpd97n5/aXYXkmBPiWUCx1SsOj1eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZkynfwtoGuI313KAjB7O6fSXAvPyMboK5TbIqsXxbgmwftlxqTNc8Yw1AOK3/fu1
         Njrfee9zoyoqgJWOg1fdoOEJZSzd7fKMjm3K9CJ1XIMpWaZY+uzJibY37eT4Gv58mB
         NIaj1PkltG1P+Ke5+j76ul0PKQS5pdk/NXl0Oe2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 4.19 018/425] erofs: add unsupported inode i_format check
Date:   Thu, 20 May 2021 11:16:27 +0200
Message-Id: <20210520092131.969869695@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
 drivers/staging/erofs/erofs_fs.h |    3 +++
 drivers/staging/erofs/inode.c    |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -71,6 +71,9 @@ enum {
 #define EROFS_I_VERSION_BIT             0
 __EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
 
+#define EROFS_I_ALL	\
+	((1 << (EROFS_I_DATA_MAPPING_BIT + EROFS_I_DATA_MAPPING_BITS)) - 1)
+
 struct erofs_inode_v1 {
 /*  0 */__le16 i_advise;
 
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -48,6 +48,12 @@ static struct page *read_inode(struct in
 	v1 = page_address(page) + *ofs;
 	ifmt = le16_to_cpu(v1->i_advise);
 
+	if (ifmt & ~EROFS_I_ALL) {
+		errln("unsupported i_format %u of nid %llu", ifmt, vi->nid);
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	vi->data_mapping_mode = __inode_data_mapping(ifmt);
 	if (unlikely(vi->data_mapping_mode >= EROFS_INODE_LAYOUT_MAX)) {
 		errln("unknown data mapping mode %u of nid %llu",


