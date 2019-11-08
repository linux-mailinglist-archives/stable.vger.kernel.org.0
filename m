Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B13F5771
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbfKHTWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732708AbfKHS4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2FF21D7E;
        Fri,  8 Nov 2019 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239412;
        bh=qtBG9KGoVwj4vVLmTJ8RrLge0p0xuVRCHL1ui7zx5Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z44crNc0FEuugk6rlhoD0LdY96bFR6icsNsxL6wyJJoXXa3WxtBRozB5lR7ZFAcFR
         skNwmLPqZi4r3+dYH+qzoKyHTJeTa1ra7iyE14irSDaIv+fXv/wmolnTO4Ac3gRm/q
         uZmybqcFry5ztew2mYBh6mEUkZ5DS1F9xdvNj4i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 30/34] kbuild: use -fmacro-prefix-map to make __FILE__ a relative path
Date:   Fri,  8 Nov 2019 19:50:37 +0100
Message-Id: <20191108174652.792481163@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
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
index 19c7e30684077..62ce3766032c9 100644
--- a/Makefile
+++ b/Makefile
@@ -837,6 +837,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=incompatible-pointer-types)
 # Require designated initializers for all marked structures
 KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 
+# change __FILE__ to the relative path from the srctree
+KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
2.20.1



