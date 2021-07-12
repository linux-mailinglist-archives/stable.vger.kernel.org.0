Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919DD3C512D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbhGLHiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238403AbhGLHfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:35:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F922613EF;
        Mon, 12 Jul 2021 07:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075133;
        bh=nmcU4SXw7M5jKwFeXSr9mRohFkJvGOJD4TgxdkI9Luc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtDWl/BpD8gsgmOFi+RhJ37Sk/9ZJL6sH7n1xborhY2saA2+t6l8BD2XrRgfoVeor
         RvDYUi9wsKdWIE7GUfUdz/XzVht05zxbajf2SKiMk8OkbK1f9G67ETuy+Hb1q2c2TP
         TDQGIQeIpn8+4BkGFXSMCV5A3m9OaC3D+pDLj4Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.13 084/800] f2fs: Prevent swap file in LFS mode
Date:   Mon, 12 Jul 2021 08:01:47 +0200
Message-Id: <20210712060924.908202074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit d927ccfccb009ede24448d69c08b12e7c8a6979b upstream.

The kernel writes to swap files on f2fs directly without the assistance
of the filesystem. This direct write by kernel can be non-sequential
even when the f2fs is in LFS mode. Such non-sequential write conflicts
with the LFS semantics. Especially when f2fs is set up on zoned block
devices, the non-sequential write causes unaligned write command errors.

To avoid the non-sequential writes to swap files, prevent swap file
activation when the filesystem is in LFS mode.

Fixes: 4969c06a0d83 ("f2fs: support swap file w/ DIO")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.10+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4067,6 +4067,12 @@ static int f2fs_swap_activate(struct swa
 	if (f2fs_readonly(F2FS_I_SB(inode)->sb))
 		return -EROFS;
 
+	if (f2fs_lfs_mode(F2FS_I_SB(inode))) {
+		f2fs_err(F2FS_I_SB(inode),
+			"Swapfile not supported in LFS mode");
+		return -EINVAL;
+	}
+
 	ret = f2fs_convert_inline_inode(inode);
 	if (ret)
 		return ret;


