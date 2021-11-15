Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D22450C68
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhKORiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237107AbhKORhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4209D60EFE;
        Mon, 15 Nov 2021 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997072;
        bh=GRLHFZEn/ryXIFvwDf0nn194ztOxHgpCL76U1cYsOCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+o7BrvazrCd3mwwTD+T6vnTUFRSz1aS4mM835vPeN/gqeskqBRcm+bls3J3IklzI
         8yjFSxXpWKv88o/uGpBOnKPw7cjDHbgPPVPre1RPHyH1o9uukGh0jUe6XgTL+9ivJx
         mZONMPWYN5fY83oZv3C8lvaI6k+YnZCL7c4rrzg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganapathi Kamath <hgkamath@hotmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 016/575] exfat: fix incorrect loading of i_blocks for large files
Date:   Mon, 15 Nov 2021 17:55:41 +0100
Message-Id: <20211115165344.174473892@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 0c336d6e33f4bedc443404c89f43c91c8bd9ee11 upstream.

When calculating i_blocks, there was a mistake that was masked with a
32-bit variable. So i_blocks for files larger than 4 GiB had incorrect
values. Mask with a 64-bit variable instead of 32-bit one.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Ganapathi Kamath <hgkamath@hotmail.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -602,7 +602,7 @@ static int exfat_fill_inode(struct inode
 	exfat_save_attr(inode, info->attr);
 
 	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-		~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+		~((loff_t)sbi->cluster_size - 1)) >> inode->i_blkbits;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;


