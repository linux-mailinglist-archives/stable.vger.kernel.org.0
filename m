Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51803C1800
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfI2Rd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbfI2Rd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:33:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F186D21928;
        Sun, 29 Sep 2019 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778438;
        bh=UjF/+zrMh2A8WpMuI+am8+4yCtxPltsqQNNdz86765Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8fsH67TJPJjal1tgb4NxjrAty4MJFIpZ7lThNoyamWnaU3Nw0OaQaaDdZU9WC02T
         asD5k5UwQJn3B6G6K0t1HhDdZvdTeIedjzTedHK7lEnSpMbutwKavF9QDNXyoXzSWp
         63wzoGTkBlMzzFrBXFUuzSZ6kuuCU1FB1T8gzdhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Thelen <gthelen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 36/42] kbuild: clean compressed initramfs image
Date:   Sun, 29 Sep 2019 13:32:35 -0400
Message-Id: <20190929173244.8918-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
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
index 4a70ae43c9cb5..bdb3f52fadc44 100644
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

