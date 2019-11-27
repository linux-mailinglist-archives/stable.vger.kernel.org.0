Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF5710BE42
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbfK0Uuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbfK0Uuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:50:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE49C2184C;
        Wed, 27 Nov 2019 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887836;
        bh=UuqkYwaEdKSFRzNCtzmdbILIkT501RlWETeJr5f1rEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyevuFZK5/wiFOT6DUldiEEW3CykJVJOf1jXzSs5mUUGkaY32lynmK3SYi8vC95aV
         B4asNMeXM29O3u1P6nckuWMAZDK70GuvAJ2XyzIhw7KDli0QIh2vD9z0WiR/V3Qi8C
         sMlQ/djhbwT1IpHz49QgG+T3p+I9XyqtgR8Egvuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" 
        <ernesto.mnd.fernandez@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/211] hfsplus: fix return value of hfsplus_get_block()
Date:   Wed, 27 Nov 2019 21:30:46 +0100
Message-Id: <20191127203104.699181119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit 839c3a6a5e1fbc8542d581911b35b2cb5cd29304 ]

Direct writes to empty inodes fail with EIO.  The generic direct-io code
is in part to blame (a patch has been submitted as "direct-io: allow
direct writes to empty inodes"), but hfsplus is worse affected than the
other filesystems because the fallback to buffered I/O doesn't happen.

The problem is the return value of hfsplus_get_block() when called with
!create.  Change it to be more consistent with the other modules.

Link: http://lkml.kernel.org/r/2cd1301404ec7cf1e39c8f11a01a4302f1460ad6.1539195310.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/extents.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 284d7fb73e863..58f296bfd4380 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -237,7 +237,9 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	ablock = iblock >> sbi->fs_shift;
 
 	if (iblock >= hip->fs_blocks) {
-		if (iblock > hip->fs_blocks || !create)
+		if (!create)
+			return 0;
+		if (iblock > hip->fs_blocks)
 			return -EIO;
 		if (ablock >= hip->alloc_blocks) {
 			res = hfsplus_file_extend(inode, false);
-- 
2.20.1



