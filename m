Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775AE32AF4B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhCCAQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350240AbhCBMOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:14:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5A064F73;
        Tue,  2 Mar 2021 11:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686251;
        bh=sV+0jxzMHLdVvX73z9/bfmOfp7Y/1hQS6IXemD7/Xdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWhun9Gtl/TGThqx46F58c62Ak9+dptjdfaCE18PUx4d8XCY5x/tidrK5xhdoQxr5
         yVNDNyW9IsoKv0CJ16zhxK4bsvK5/xqn9t9Os1szd5tcuPrd+nzPd4oMpmywXEIPMT
         p2DGbGRnqo16NMowqXmo22BgfcPsJIdA1tH5XVS3COrz/v+A3O0P0TzOvvlJk5jlZs
         krZfwuMOt81MOYsF+7Rs6W/KPmVPGKD/S2OeVwZavHhGJsYg11qnZHlRoCK9YC7Dlw
         qLyGbOYdPLrlE/AxKJS7Nb6djZFu+l5A7txoNXKtSr0CPV+k6Q5mmqw9rhXa07s49q
         e6yl4+5w9hevw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/47] kbuild: clamp SUBLEVEL to 255
Date:   Tue,  2 Mar 2021 06:56:35 -0500
Message-Id: <20210302115646.62291-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b82f13e7ef316cdc0a8858f1349f4defce3f9e0 ]

Right now if SUBLEVEL becomes larger than 255 it will overflow into the
territory of PATCHLEVEL, causing havoc in userspace that tests for
specific kernel version.

While userspace code tests for MAJOR and PATCHLEVEL, it doesn't test
SUBLEVEL at any point as ABI changes don't happen in the context of
stable tree.

Thus, to avoid overflows, simply clamp SUBLEVEL to it's maximum value in
the context of LINUX_VERSION_CODE. This does not affect "make
kernelversion" and such.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index f700bdea626d..006011904269 100644
--- a/Makefile
+++ b/Makefile
@@ -1247,9 +1247,15 @@ define filechk_utsrelease.h
 endef
 
 define filechk_version.h
-	echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
-	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
+	if [ $(SUBLEVEL) -gt 255 ]; then                                 \
+		echo \#define LINUX_VERSION_CODE $(shell                 \
+		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
+	else                                                             \
+		echo \#define LINUX_VERSION_CODE $(shell                 \
+		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
+	fi;                                                              \
+	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
+	((c) > 255 ? 255 : (c)))'
 endef
 
 $(version_h): FORCE
-- 
2.30.1

