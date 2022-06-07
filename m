Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337E8540834
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348772AbiFGR42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348710AbiFGRyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051161447B7;
        Tue,  7 Jun 2022 10:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89640B822B3;
        Tue,  7 Jun 2022 17:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042BEC385A5;
        Tue,  7 Jun 2022 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623593;
        bh=EDfiEudIZu9zvUw34ntLxy+KuAi9Pz0BPsPElTT9fvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeVJfrYFH39sLcRK7tNZy3Aa0qHJ0gjMScbpUeo5jtLTXDUuxVnd/BWfPXqiYQLbk
         UQOdL8BdhrbRPq/6Yn70FUcGj59grsYvAA853XNfUZCHSfCb9Bdc0Mdo8ByA54Jfbt
         udmOSUpKd3q7QDKFVS9G6UckF6rzRoqOZlwciYW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 021/667] fs/ntfs3: Fix fiemap + fix shrink file size (to remove preallocated space)
Date:   Tue,  7 Jun 2022 18:54:46 +0200
Message-Id: <20220607164935.431857829@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 3880f2b816a7e4ca889b7e8a42e6c62c5706ed36 upstream.

Two problems:
1. ntfs3_setattr can't truncate preallocated space;
2. if allocated fragment "cross" valid size, then fragment splits into two parts:
- normal part;
- unwritten part (here we must return FIEMAP_EXTENT_LAST).
Before this commit we returned FIEMAP_EXTENT_LAST for whole fragment.
Fixes xfstest generic/092
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c    |    2 +-
 fs/ntfs3/frecord.c |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -761,7 +761,7 @@ int ntfs3_setattr(struct user_namespace
 		}
 		inode_dio_wait(inode);
 
-		if (attr->ia_size < oldsize)
+		if (attr->ia_size <= oldsize)
 			err = ntfs_truncate(inode, attr->ia_size);
 		else if (attr->ia_size > oldsize)
 			err = ntfs_extend(inode, attr->ia_size, 0, NULL);
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1964,10 +1964,8 @@ int ni_fiemap(struct ntfs_inode *ni, str
 
 		vcn += clen;
 
-		if (vbo + bytes >= end) {
+		if (vbo + bytes >= end)
 			bytes = end - vbo;
-			flags |= FIEMAP_EXTENT_LAST;
-		}
 
 		if (vbo + bytes <= valid) {
 			;
@@ -1977,6 +1975,9 @@ int ni_fiemap(struct ntfs_inode *ni, str
 			/* vbo < valid && valid < vbo + bytes */
 			u64 dlen = valid - vbo;
 
+			if (vbo + dlen >= end)
+				flags |= FIEMAP_EXTENT_LAST;
+
 			err = fiemap_fill_next_extent(fieinfo, vbo, lbo, dlen,
 						      flags);
 			if (err < 0)
@@ -1995,6 +1996,9 @@ int ni_fiemap(struct ntfs_inode *ni, str
 			flags |= FIEMAP_EXTENT_UNWRITTEN;
 		}
 
+		if (vbo + bytes >= end)
+			flags |= FIEMAP_EXTENT_LAST;
+
 		err = fiemap_fill_next_extent(fieinfo, vbo, lbo, bytes, flags);
 		if (err < 0)
 			break;


