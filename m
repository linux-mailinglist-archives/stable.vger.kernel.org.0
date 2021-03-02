Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED49332AFD8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbhCCA3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444802AbhCBMgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:36:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FD764F3E;
        Tue,  2 Mar 2021 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686186;
        bh=ab5hniXl98VxlN0bmfQq67BF1biy4T23u0IOq90Wync=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arUhwyV+0TP+8O9VzQNPkHnzq9cpRy1KLhXbs54gCctgkx6mLhADmT0ZOYL3qVdcn
         c4cxFhc543j5SikmydAVJi24LysOFA2IaHgRzNNqrQjk0VsXpwPJsHLb0eR83iNMa3
         ng2h0ViLjmdZO9GbeQPQ7art/6uoZlyMl6nzn6EsLEB01hNM2VrkxM1G6xLuv4Ztcq
         Gz6DcCvsAVyc8hCylaKWoiHgxn3UVJWuIC6gU2EqzKduAvS5AyT6JC4Hgw0y0Nw/It
         qi8mUDwknWXSqXxtGwsaUfVSNxysUO1dQinwQG7TvzHzGmpPqH6idUjwsmMrNS4dYG
         o9+yaFAF1A0ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 40/52] kbuild: clamp SUBLEVEL to 255
Date:   Tue,  2 Mar 2021 06:55:21 -0500
Message-Id: <20210302115534.61800-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 0b9ae470a714..bcd11b3d4ced 100644
--- a/Makefile
+++ b/Makefile
@@ -1246,9 +1246,15 @@ define filechk_utsrelease.h
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

