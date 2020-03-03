Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C65E176C14
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgCCCtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbgCCCtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E152E24699;
        Tue,  3 Mar 2020 02:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203761;
        bh=66QW2+ESPuzoUmehFdhSS+d4CRWx0EfkVdbM2bdSjKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBp9pawZPEBoSV/2SRxyWvCAL+tUwSU2w4molBhcuXBCRgGFlNjXOtXS6MoCORjPh
         8LzzQFROv+ueOFV/lVCJgh2kl/Rf6HM9BBj2qm+2tVIxYJRmkuwAh1n1dlV+7ZNwfS
         RC+K8228KXQ92QML5XX1/kLqXaOOk3NSuO07ZpxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/32] s390: make 'install' not depend on vmlinux
Date:   Mon,  2 Mar 2020 21:48:42 -0500
Message-Id: <20200303024851.10054-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 94e90f727f7424d827256023cace829cad6896f4 ]

For the same reason as commit 19514fc665ff ("arm, kbuild: make "make
install" not depend on vmlinux"), the install targets should never
trigger the rebuild of the kernel.

The variable, CONFIGURE, is not set by anyone. Remove it as well.

Link: https://lkml.kernel.org/r/20200216144829.27023-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Makefile      | 2 +-
 arch/s390/boot/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 4bccde36cb161..9a3a698c8fca5 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -140,7 +140,7 @@ all: bzImage
 #KBUILD_IMAGE is necessary for packaging targets like rpm-pkg, deb-pkg...
 KBUILD_IMAGE	:= $(boot)/bzImage
 
-install: vmlinux
+install:
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
 bzImage: vmlinux
diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index f6a9b0c203553..45c72d1f9e7d2 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -46,7 +46,7 @@ quiet_cmd_ar = AR      $@
 $(obj)/startup.a: $(OBJECTS) FORCE
 	$(call if_changed,ar)
 
-install: $(CONFIGURE) $(obj)/bzImage
+install:
 	sh -x  $(srctree)/$(obj)/install.sh $(KERNELRELEASE) $(obj)/bzImage \
 	      System.map "$(INSTALL_PATH)"
 
-- 
2.20.1

