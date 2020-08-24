Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D079C24FA3B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHXIhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgHXIhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2912F207DF;
        Mon, 24 Aug 2020 08:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258240;
        bh=/VkEBIuziD8SgmNEKbfaVGxr7/U3/MYSmlfd1mWutaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng8VPhm+2vc2WgUfPdhkfU8ZwAUMWXsUhC6wkzJISctiMbPtuoksMfvuS1DH0Uxio
         5EF+/lV4h8axJ0VQlldG3C4kByXNd4FrdN+069o8DKwAOWucvoYHo+ncGdJF6RIZMi
         JFREtgDnXfxoXADXI281EMJLf2DXHLN+z5xIiepU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 127/148] ARM64: vdso32: Install vdso32 from vdso_install
Date:   Mon, 24 Aug 2020 10:30:25 +0200
Message-Id: <20200824082420.098230490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 8d75785a814241587802655cc33e384230744f0c ]

Add the 32-bit vdso Makefile to the vdso_install rule so that 'make
vdso_install' installs the 32-bit compat vdso when it is compiled.

Fixes: a7f71a2c8903 ("arm64: compat: Add vDSO")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20200818014950.42492-1-swboyd@chromium.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile               | 1 +
 arch/arm64/kernel/vdso32/Makefile | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 70f5905954dde..91e377770a6b8 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -158,6 +158,7 @@ zinstall install:
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
+	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso32 $@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 5139a5f192568..d6adb4677c25f 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -208,7 +208,7 @@ quiet_cmd_vdsosym = VDSOSYM $@
       cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
 
 # Install commands for the unstripped file
-quiet_cmd_vdso_install = INSTALL $@
+quiet_cmd_vdso_install = INSTALL32 $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/vdso32.so
 
 vdso.so: $(obj)/vdso.so.dbg
-- 
2.25.1



