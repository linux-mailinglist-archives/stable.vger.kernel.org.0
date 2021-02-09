Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E82A315A14
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhBIXcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233865AbhBIWRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68B6D64ED3;
        Tue,  9 Feb 2021 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906938;
        bh=Hz+xFEDLQbLz7sIpeqc/i/vMtdm3bEADpBa/hneV2O4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d+AkoTsbXU4HvL5HcZ0kXBP9P2bLLSQPJLI+36OpdIERUgjH3tmwIINNuQYM5Jw+/
         LiTswwHHeNhmqjAMaiYNTLoi56B3fRGRMz0ZJpmY/doAOBUVINFnygLi8lJ3Vwa+5z
         vzKh/nd2sc9IoRbNaB56Ckh4XXJlBgUcO1D4CYZ4=
Date:   Tue, 09 Feb 2021 13:42:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amir73il@gmail.com,
        chris@chrisdown.name, hughd@google.com, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rth@twiddle.net, seth.forshee@canonical.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on
 alpha
Message-ID: <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>
Subject: tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha

As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
display "inode64" in the mount options, whereas passing "inode64" in the
mount options will fail.  This leads to erroneous behaviours such as this:

 # mkdir mnt
 # mount -t tmpfs nodev mnt
 # mount -o remount,rw mnt
 mount: /home/ubuntu/mnt: mount point not mounted or bad option.

Prevent CONFIG_TMPFS_INODE64 from being selected on alpha.

Link: https://lkml.kernel.org/r/20210208215726.608197-1-seth.forshee@canonical.com
Fixes: ea3271f7196c ("tmpfs: support 64-bit inums per-sb")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/Kconfig~tmpfs-disallow-config_tmpfs_inode64-on-alpha
+++ a/fs/Kconfig
@@ -203,7 +203,7 @@ config TMPFS_XATTR
 
 config TMPFS_INODE64
 	bool "Use 64-bit ino_t by default in tmpfs"
-	depends on TMPFS && 64BIT && !S390
+	depends on TMPFS && 64BIT && !(S390 || ALPHA)
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
_
