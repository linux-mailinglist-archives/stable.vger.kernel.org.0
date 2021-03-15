Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7575733B789
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhCOOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhCON71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B135664F2D;
        Mon, 15 Mar 2021 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816742;
        bh=0KiJ5mnokOVvD5sEl1axOX46e0RnlfG0HeqRb906NkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKQCPBrpaUejd5DS+bH4p+W0zwAwBnuLN+bj4MuclBjBkdMHqJ0A8frbWkA34o67i
         +i2Iu3QJ6GUdLTnEJli0Wzc3xkVQcV04lBGVGe/xp0SLofLLX6b8+NMc7qhTFOPmt/
         nrbDDEszWRKAa9HkWG7EtFR8RcOXFoHEGEsEHThw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 080/168] kbuild: clamp SUBLEVEL to 255
Date:   Mon, 15 Mar 2021 14:55:12 +0100
Message-Id: <20210315135553.018784874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index e27d031f3241..00be167f9b13 100644
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



