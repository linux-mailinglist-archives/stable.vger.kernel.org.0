Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4527344342
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhCVMtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhCVMrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4384061998;
        Mon, 22 Mar 2021 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417018;
        bh=MzPnXL8wXz1wTRy1tfGCo/Df+IPc0EHxuz5Qex7v8DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bG8xPwF32xKheQN9X2PLA20uADvl1PVBT/Jr329Bs/bApdZHZJ5gzgYkHNxVgdGv7
         o+XMfJEavVkoGL4sQYBhb0Gfi2FYIryYSMQh6DWiFETuS4xnhNPAuaPPUkm2mSniAh
         hTwNB9x+LkptxfAIwvzuaAaDZFJjPCJZjKzxyYBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/60] kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL again
Date:   Mon, 22 Mar 2021 13:28:16 +0100
Message-Id: <20210322121923.314340599@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 207da4c82ade9a6d59f7e794d737ba0748613fa2 upstream.

Commit 78d3bb4483ba ("kbuild: Fix <linux/version.h> for empty SUBLEVEL
or PATCHLEVEL") fixed the build error for empty SUBLEVEL or PATCHLEVEL
by prepending a zero.

Commit 9b82f13e7ef3 ("kbuild: clamp SUBLEVEL to 255") re-introduced
this issue.

This time, we cannot take the same approach because we have C code:

  #define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL)
  #define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)

Replace empty SUBLEVEL/PATCHLEVEL with a zero.

Fixes: 9b82f13e7ef3 ("kbuild: clamp SUBLEVEL to 255")
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1177,15 +1177,17 @@ endef
 define filechk_version.h
 	if [ $(SUBLEVEL) -gt 255 ]; then                                 \
 		echo \#define LINUX_VERSION_CODE $(shell                 \
-		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
+		expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + 255); \
 	else                                                             \
 		echo \#define LINUX_VERSION_CODE $(shell                 \
-		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
+		expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
 	fi;                                                              \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
 	((c) > 255 ? 255 : (c)))'
 endef
 
+$(version_h): PATCHLEVEL := $(if $(PATCHLEVEL), $(PATCHLEVEL), 0)
+$(version_h): SUBLEVEL := $(if $(SUBLEVEL), $(SUBLEVEL), 0)
 $(version_h): FORCE
 	$(call filechk,version.h)
 	$(Q)rm -f $(old_version_h)


