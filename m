Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB832AF80
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbhCCAZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350347AbhCBMVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32BD764F96;
        Tue,  2 Mar 2021 11:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686303;
        bh=mb5XzPjVA/Wj9FalGbm9ViAa4f0b2wEYV8rnPIqdjVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQz2OYVnwaJsdoIs+/UTLJM2zR+5uGfaNC5n45pj+dEOa6DS1LGBJatv5dvLD9263
         2WatUTNsLGFcWB65eNQKvCxRx2fhkTRgNMyaNov3X7Xi/gaQ2zXokh2DgNqAZOlKt/
         SuqvRf0eidui5+8P6phhJjbOfotUcK9zPB8LzrNXYllfbFIEkjEdM4a7Vt46WjBjxW
         8DSWfLEfMxeO+f+3LKm/LqL65EJ6CKQv7RlKj47y0+l3ByfT9f/Ql1KYrfLiSn21sc
         O3EANf7X3c8IAV6YwhkKW9B1ycKbMz1ZKWwzw2umfach0MNGZgqSYUTpxM1UPKxD3g
         TpAQS4hOszi+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/33] kbuild: clamp SUBLEVEL to 255
Date:   Tue,  2 Mar 2021 06:57:41 -0500
Message-Id: <20210302115749.62653-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
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
index f56442751d2c..e8a1989032bd 100644
--- a/Makefile
+++ b/Makefile
@@ -1175,9 +1175,15 @@ define filechk_utsrelease.h
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

