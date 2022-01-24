Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7643B4996D0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348933AbiAXVG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42722 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352944AbiAXUs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E67E060B28;
        Mon, 24 Jan 2022 20:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AB7C340E5;
        Mon, 24 Jan 2022 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057334;
        bh=bA2NVkNRdfsC9+kYNk0cI6zBu7bM2DrL1aL/zdydw6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/fVEkRcbkJe7tPFi9aLqOFs6oksTRlwC2GyHUdQiapjUTlLPQmCYCD7CHHVsmLCV
         idgkX8JGxSh5otukfH2OXBTtStYO6Q7C8lJ7MTROjLFMVIxNtLxO3pVtegv2/eokeI
         /HFPlCWM1RTe64EL8KJrlWQanxBWGGfKs43ixqOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <changfengnan@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 778/846] f2fs: fix remove page failed in invalidate compress pages
Date:   Mon, 24 Jan 2022 19:44:55 +0100
Message-Id: <20220124184127.791801437@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <changfengnan@vivo.com>

commit d1917865a7906baf6b687e15e8e6195a295a3992 upstream.

Since compress inode not a regular file, generic_error_remove_page in
f2fs_invalidate_compress_pages will always be failed, set compress
inode as a regular file to fix it.

Fixes: 6ce19aff0b8c ("f2fs: compress: add compress_inode to cache compressed blocks")
Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -516,6 +516,11 @@ make_now:
 	} else if (ino == F2FS_COMPRESS_INO(sbi)) {
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		inode->i_mapping->a_ops = &f2fs_compress_aops;
+		/*
+		 * generic_error_remove_page only truncates pages of regular
+		 * inode
+		 */
+		inode->i_mode |= S_IFREG;
 #endif
 		mapping_set_gfp_mask(inode->i_mapping,
 			GFP_NOFS | __GFP_HIGHMEM | __GFP_MOVABLE);


