Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0585A40E247
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbhIPQgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhIPQdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0465E613A2;
        Thu, 16 Sep 2021 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809205;
        bh=WB562ppGrXpRjcf0C5XbCaUMLjcnT/uVFt2p/QwcutQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz9KPxXUss3c9YMxcI3w9aJJi5sc5kymvNISuGvvvZaQBZsOaaNFvkfnnQLd1N2zT
         IjMG7CdCXtgIS20izB4cg9Ae9unLXJwqlLqFqdCSG6uBdUrwLXUhQw/1Yq0omKc2AS
         0C3QOTjBSsE1Yi4dzzfRzPmoANTVcpMdp0MCAD4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, 5kft <5kft@5kft.org>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/380] f2fs: compress: fix to set zstd compress level correctly
Date:   Thu, 16 Sep 2021 17:57:05 +0200
Message-Id: <20210916155806.303782127@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 01f6afd0f3ccaa2d5f7fb87e7bd910dc17eef06b ]

As 5kft reported in [1]:

set_compress_context() should set compress level into .i_compress_flag
for zstd as well as lz4hc, otherwise, zstd compressor will still use
default zstd compress level during compression, fix it.

[1] https://lore.kernel.org/linux-f2fs-devel/8e29f52b-6b0d-45ec-9520-e63eb254287a@www.fastmail.com/T/#u

Fixes: 3fde13f817e2 ("f2fs: compress: support compress level")
Reported-by: 5kft <5kft@5kft.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a5de48e768d7..71af6a64a241 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4020,7 +4020,8 @@ static inline void set_compress_context(struct inode *inode)
 				1 << COMPRESS_CHKSUM : 0;
 	F2FS_I(inode)->i_cluster_size =
 			1 << F2FS_I(inode)->i_log_cluster_size;
-	if (F2FS_I(inode)->i_compress_algorithm == COMPRESS_LZ4 &&
+	if ((F2FS_I(inode)->i_compress_algorithm == COMPRESS_LZ4 ||
+		F2FS_I(inode)->i_compress_algorithm == COMPRESS_ZSTD) &&
 			F2FS_OPTION(sbi).compress_level)
 		F2FS_I(inode)->i_compress_flag |=
 				F2FS_OPTION(sbi).compress_level <<
-- 
2.30.2



