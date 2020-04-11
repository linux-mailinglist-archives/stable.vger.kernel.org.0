Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944EE1A51B1
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgDKM1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbgDKMOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5505A20644;
        Sat, 11 Apr 2020 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607259;
        bh=XMf7QVap6ODLiVJo0XE8+jiJoxTHwXWjdNCTTv0ulBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlhIySmmepDmafWVbuw3y4tAqlbGdc/X9vDACkCTwUo8K620Q2o01mdoNh4BnhJGZ
         LfXKBn3SCgu/+mvUpI6gsejP+M5jmdBfpe1SV6iBetV+vuJE3OEBVK5+6tGR2E76fC
         uVl4yPlibWcRGVZ2xuCSh/Ny2FmZ+us0SMdPcTqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/38] initramfs: restore default compression behavior
Date:   Sat, 11 Apr 2020 14:08:50 +0200
Message-Id: <20200411115438.559376676@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 43658b8a975e5..8b4826de1189f 100644
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



