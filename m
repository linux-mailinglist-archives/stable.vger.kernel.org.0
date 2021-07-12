Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F196D3C481B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhGLGfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236064AbhGLGfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5390A60FD8;
        Mon, 12 Jul 2021 06:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071531;
        bh=Mh1xYXqDgxwjQsgpEKT7aCHD9SmgnJVg0RLjNmFRuR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9avDCV2ChJ5M7E3Mg4T/YLcpeM9FT89AF4vyH+geo6SzKc3OsFYNZWq7/AFx43vr
         yprgwiZZCWSw9LVt/vCX90NBQbWUjm28bJV/UNQ41PJlo/zZ/K0UE9a26nXAwPcHYa
         wqBhuWJFzPyROmVtdzKSLLQepkR4rupuW4t0gJJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 067/593] f2fs: Prevent swap file in LFS mode
Date:   Mon, 12 Jul 2021 08:03:47 +0200
Message-Id: <20210712060850.544487731@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -4112,6 +4112,12 @@ static int f2fs_swap_activate(struct swa
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


