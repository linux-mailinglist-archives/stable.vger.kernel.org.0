Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248DC29BEBC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814528AbgJ0Q4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794139AbgJ0PKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF4620657;
        Tue, 27 Oct 2020 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811408;
        bh=In6ODsqjDUsLruB/vRc+eDv8J/cXj5mUeu0tSPrUbnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaziSQlLJ7P3O+MZDJ485fcM4B52xfqjxkuLiueJaoXjmipkHZGCySKlR0YY6hjdn
         /yOgXN1tsEMWB4QC0g6kg2cDLmRcUj/L7Hz+vmTtsrf42Kp5jftzj7dzVK7+ykKQRg
         cknG9hzOQVgTOphXKqtGn51H4Xe7MyGMMjq9CZWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 452/633] kbuild: deb-pkg: do not build linux-headers package if CONFIG_MODULES=n
Date:   Tue, 27 Oct 2020 14:53:15 +0100
Message-Id: <20201027135543.921506910@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit bac977cbc0d6731fb8e67c2be0e4acbd959e10b3 ]

Since commit 269a535ca931 ("modpost: generate vmlinux.symvers and
reuse it for the second modpost"), with CONFIG_MODULES disabled,
"make deb-pkg" (or "make bindeb-pkg") fails with:

  find: ‘Module.symvers’: No such file or directory

If CONFIG_MODULES is disabled, it doesn't really make sense to build
the linux-headers package.

Fixes: 269a535ca931 ("modpost: generate vmlinux.symvers and reuse it for the second modpost")
Reported-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/builddeb |  6 ++++--
 scripts/package/mkdebian | 19 ++++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 6df3c9f8b2da6..8277144298a00 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -202,8 +202,10 @@ EOF
 done
 
 if [ "$ARCH" != "um" ]; then
-	deploy_kernel_headers debian/linux-headers
-	create_package linux-headers-$version debian/linux-headers
+	if is_enabled CONFIG_MODULES; then
+		deploy_kernel_headers debian/linux-headers
+		create_package linux-headers-$version debian/linux-headers
+	fi
 
 	deploy_libc_headers debian/linux-libc-dev
 	create_package linux-libc-dev debian/linux-libc-dev
diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index df1adbfb8ead0..9342517778bf3 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -183,13 +183,6 @@ Description: Linux kernel, version $version
  This package contains the Linux kernel, modules and corresponding other
  files, version: $version.
 
-Package: $kernel_headers_packagename
-Architecture: $debarch
-Description: Linux kernel headers for $version on $debarch
- This package provides kernel header files for $version on $debarch
- .
- This is useful for people who need to build external modules
-
 Package: linux-libc-dev
 Section: devel
 Provides: linux-kernel-headers
@@ -200,6 +193,18 @@ Description: Linux support headers for userspace development
 Multi-Arch: same
 EOF
 
+if is_enabled CONFIG_MODULES; then
+cat <<EOF >> debian/control
+
+Package: $kernel_headers_packagename
+Architecture: $debarch
+Description: Linux kernel headers for $version on $debarch
+ This package provides kernel header files for $version on $debarch
+ .
+ This is useful for people who need to build external modules
+EOF
+fi
+
 if is_enabled CONFIG_DEBUG_INFO; then
 cat <<EOF >> debian/control
 
-- 
2.25.1



