Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DB1C16B5
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbfI2RcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbfI2RcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9083121928;
        Sun, 29 Sep 2019 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778338;
        bh=tujCGr7UP/h6vSuTp2ArqlTn+oTyd38Cvba0/sHfhyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aci7cjnokSjHdWx9aAgT5ExOP678KSMz2M8MT5TUIJTupQdipaoX8CZ7RMPk2VGzV
         Q/NzC1gkWtHDdeL0tZSyWlLWdQFOKS0ZO42VrUV0Gzx1LU7C98agzyvbn4gGfzN0th
         8DSx2EWXU5/SpknjsbqJM3KX2Dv+DKo9k7NTbc84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Thelen <gthelen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 43/49] kbuild: clean compressed initramfs image
Date:   Sun, 29 Sep 2019 13:30:43 -0400
Message-Id: <20190929173053.8400-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 6279eb3dd7946c69346a3b98473ed13d3a44adb5 ]

Since 9e3596b0c653 ("kbuild: initramfs cleanup, set target from Kconfig")
"make clean" leaves behind compressed initramfs images.  Example:

  $ make defconfig
  $ sed -i 's|CONFIG_INITRAMFS_SOURCE=""|CONFIG_INITRAMFS_SOURCE="/tmp/ir.cpio"|' .config
  $ make olddefconfig
  $ make -s
  $ make -s clean
  $ git clean -ndxf | grep initramfs
  Would remove usr/initramfs_data.cpio.gz

clean rules do not have CONFIG_* context so they do not know which
compression format was used.  Thus they don't know which files to delete.

Tell clean to delete all possible compression formats.

Once patched usr/initramfs_data.cpio.gz and friends are deleted by
"make clean".

Link: http://lkml.kernel.org/r/20190722063251.55541-1-gthelen@google.com
Fixes: 9e3596b0c653 ("kbuild: initramfs cleanup, set target from Kconfig")
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/usr/Makefile b/usr/Makefile
index 6a89eb019275b..e6f7cb2f81db4 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -11,6 +11,9 @@ datafile_y = initramfs_data.cpio$(suffix_y)
 datafile_d_y = .$(datafile_y).d
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/$(datafile_y)"
 
+# clean rules do not have CONFIG_INITRAMFS_COMPRESSION.  So clean up after all
+# possible compression formats.
+clean-files += initramfs_data.cpio*
 
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
-- 
2.20.1

