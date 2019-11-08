Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749FAF5505
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389323AbfKHS77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731773AbfKHS77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0EC22559;
        Fri,  8 Nov 2019 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239598;
        bh=GrDR/KfEa55q+XgH6XKOcuelZG4bs5H5zJITdZsvvvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA3bl08A2Qzg1NKeeWm6S9UllzWHdyzIytKr0AUF3wThmp2Se/gftNbuz7Igo1sUD
         Hzl2hW9k93gEL0oiraEul3sJi+NzfXC7KvyYHzxaQByqykECm6yMDm9cFqn+TAmeKi
         e0mUIN+8FIzEZxa0iQpD1fjbFiNd8N2vR6sPczrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 52/62] kbuild: use -fmacro-prefix-map to make __FILE__ a relative path
Date:   Fri,  8 Nov 2019 19:50:40 +0100
Message-Id: <20191108174755.304501752@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit a73619a845d5625079cc1b3b820f44c899618388 ]

The __FILE__ macro is used everywhere in the kernel to locate the file
printing the log message, such as WARN_ON(), etc.  If the kernel is
built out of tree, this can be a long absolute path, like this:

  WARNING: CPU: 1 PID: 1 at /path/to/build/directory/arch/arm64/kernel/foo.c:...

This is because Kbuild runs in the objtree instead of the srctree,
then __FILE__ is expanded to a file path prefixed with $(srctree)/.

Commit 9da0763bdd82 ("kbuild: Use relative path when building in a
subdir of the source tree") improved this to some extent; $(srctree)
becomes ".." if the objtree is a child of the srctree.

For other cases of out-of-tree build, __FILE__ is still the absolute
path.  It also means the kernel image depends on where it was built.

A brand-new option from GCC, -fmacro-prefix-map, solves this problem.
If your compiler supports it, __FILE__ is the relative path from the
srctree regardless of O= option.  This provides more readable log and
more reproducible builds.

Please note __FILE__ is always an absolute path for external modules.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 1d7f47334ca2b..61660387eb34b 100644
--- a/Makefile
+++ b/Makefile
@@ -840,6 +840,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=incompatible-pointer-types)
 # Require designated initializers for all marked structures
 KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 
+# change __FILE__ to the relative path from the srctree
+KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
2.20.1



