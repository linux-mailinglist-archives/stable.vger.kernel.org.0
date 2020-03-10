Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9694C17F9AC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbgCJM7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbgCJM7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A4920674;
        Tue, 10 Mar 2020 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845141;
        bh=iOTOzWvnEBWJ2lYE1qrTSa8s9PYi2HDkCLTTQGhOrkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbPhe1/niYKJnYb0PGQwTfmNL4O0mGaIxk97drDMTGCI1z9LC8rtvGgRDkyf6Fp8R
         FO5Bg0bPawj4OUadb8jQTFIJWGSL5IlDpNNzHFfYyxiALFU3SGTzJ0NwvfNJTXim4Y
         1OERPWgd1p2QY3pzBcsrXWJoE8y4EVN8yVCPy9C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 039/189] s390: make install not depend on vmlinux
Date:   Tue, 10 Mar 2020 13:37:56 +0100
Message-Id: <20200310123643.432948299@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e0e3a465bbfd6..8dfa2cf1f05c7 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -146,7 +146,7 @@ all: bzImage
 #KBUILD_IMAGE is necessary for packaging targets like rpm-pkg, deb-pkg...
 KBUILD_IMAGE	:= $(boot)/bzImage
 
-install: vmlinux
+install:
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
 bzImage: vmlinux
diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index e2c47d3a1c891..0ff9261c915e3 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -70,7 +70,7 @@ $(obj)/compressed/vmlinux: $(obj)/startup.a FORCE
 $(obj)/startup.a: $(OBJECTS) FORCE
 	$(call if_changed,ar)
 
-install: $(CONFIGURE) $(obj)/bzImage
+install:
 	sh -x  $(srctree)/$(obj)/install.sh $(KERNELRELEASE) $(obj)/bzImage \
 	      System.map "$(INSTALL_PATH)"
 
-- 
2.20.1



