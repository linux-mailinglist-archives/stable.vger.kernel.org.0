Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CA3194D03
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCZX2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgCZXYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C184F20936;
        Thu, 26 Mar 2020 23:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265080;
        bh=ZRHdGGkfhDo9JmWaKIaBpioaKTS8YGwYZySmOSLLH3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hot6m/CXaFj5gxR8PQiKRYYcqvrqA6chSIktvl9lpxz2kEV+atKwo/GDnFu1cidmS
         wEhoq7Ss4ws/uzba1Q/TzEqTc3OpcAwls5wNncTlSGwpA87as97qK2LufSXJY+Q2Lb
         O5hGFtEO+qUah80kDoWVdZ5UqFoVc6f0dTeNw7c4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 07/19] initramfs: restore default compression behavior
Date:   Thu, 26 Mar 2020 19:24:19 -0400
Message-Id: <20200326232431.7816-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

[ Upstream commit 785d74ec3bbf26ac7f6e92e6e96a259aec0f107a ]

Even though INITRAMFS_SOURCE kconfig option isn't set in most of
defconfigs it is used (set) extensively by various build systems.
Commit f26661e12765 ("initramfs: make initramfs compression choice
non-optional") has changed default compression mode. Previously we
compress initramfs using available compression algorithm. Now
we don't use any compression at all by default.
It significantly increases the image size in case of build system
chooses embedded initramfs. Initially I faced with this issue while
using buildroot.

As of today it's not possible to set preferred compression mode
in target defconfig as this option depends on INITRAMFS_SOURCE
being set. Modification of all build systems either doesn't look
like good option.

Let's instead rewrite initramfs compression mode choices list
the way that "INITRAMFS_COMPRESSION_NONE" will be the last option
in the list. In that case it will be chosen only if all other
options (which implements any compression) are not available.

Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/Kconfig | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index a6b68503d1774..a80cc79722745 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -131,17 +131,6 @@ choice
 
 	  If in doubt, select 'None'
 
-config INITRAMFS_COMPRESSION_NONE
-	bool "None"
-	help
-	  Do not compress the built-in initramfs at all. This may sound wasteful
-	  in space, but, you should be aware that the built-in initramfs will be
-	  compressed at a later stage anyways along with the rest of the kernel,
-	  on those architectures that support this. However, not compressing the
-	  initramfs may lead to slightly higher memory consumption during a
-	  short time at boot, while both the cpio image and the unpacked
-	  filesystem image will be present in memory simultaneously
-
 config INITRAMFS_COMPRESSION_GZIP
 	bool "Gzip"
 	depends on RD_GZIP
@@ -214,6 +203,17 @@ config INITRAMFS_COMPRESSION_LZ4
 	  If you choose this, keep in mind that most distros don't provide lz4
 	  by default which could cause a build failure.
 
+config INITRAMFS_COMPRESSION_NONE
+	bool "None"
+	help
+	  Do not compress the built-in initramfs at all. This may sound wasteful
+	  in space, but, you should be aware that the built-in initramfs will be
+	  compressed at a later stage anyways along with the rest of the kernel,
+	  on those architectures that support this. However, not compressing the
+	  initramfs may lead to slightly higher memory consumption during a
+	  short time at boot, while both the cpio image and the unpacked
+	  filesystem image will be present in memory simultaneously
+
 endchoice
 
 config INITRAMFS_COMPRESSION
-- 
2.20.1

