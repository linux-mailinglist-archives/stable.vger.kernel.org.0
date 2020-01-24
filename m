Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E4F147FE8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbgAXLGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389033AbgAXLGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A32002075D;
        Fri, 24 Jan 2020 11:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863970;
        bh=xKHSoBL6SJRSZ+WtJgNnD0SOQ00KZpG9nblBKjopJXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYzpeL4Qd32QqOONHpIAo47OdRp9yxJQITSNvxNeu2FpTGIPsoBBmDmmZ822lZ8v6
         uOjY8iu2hWxtdY80Fc/a5tEBw2EC4RQjpDOtLDdkbw/yuZX2UGrZnOypKQDYaASQrJ
         P99zKN6dCLuf3RDba3f+6UTGNzaZPRZuCJRgGYeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/639] kbuild: mark prepare0 as PHONY to fix external module build
Date:   Fri, 24 Jan 2020 10:25:05 +0100
Message-Id: <20200124093104.185817170@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit e00d8880481497474792d28c14479a9fb6752046 ]

Commit c3ff2a5193fa ("powerpc/32: add stack protector support")
caused kernel panic on PowerPC when an external module is used with
CONFIG_STACKPROTECTOR because the 'prepare' target was not executed
for the external module build.

Commit e07db28eea38 ("kbuild: fix single target build for external
module") turned it into a build error because the 'prepare' target is
now executed but the 'prepare0' target is missing for the external
module build.

External module on arm/arm64 with CONFIG_STACKPROTECTOR_PER_TASK is
also broken in the same way.

Move 'PHONY += prepare0' to the common place. GNU Make is fine with
missing rule for phony targets. I also removed the comment which is
wrong irrespective of this commit.

I minimize the change so it can be easily backported to 4.20.x

To fix v4.20, please backport e07db28eea38 ("kbuild: fix single target
build for external module"), and then this commit.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=201891
Fixes: e07db28eea38 ("kbuild: fix single target build for external module")
Fixes: c3ff2a5193fa ("powerpc/32: add stack protector support")
Fixes: 189af4657186 ("ARM: smp: add support for per-task stack canaries")
Fixes: 0a1213fa7432 ("arm64: enable per-task stack canaries")
Cc: linux-stable <stable@vger.kernel.org> # v4.20
Reported-by: Samuel Holland <samuel@sholland.org>
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 48dbafb790ff1..9ceecb038356d 100644
--- a/Makefile
+++ b/Makefile
@@ -964,6 +964,7 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+PHONY += prepare0
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
@@ -1072,8 +1073,7 @@ scripts: scripts_basic asm-generic gcc-plugins $(autoksyms_h)
 # archprepare is used in arch Makefiles and when processed asm symlink,
 # version.h and scripts_basic is processed / created.
 
-# Listed in dependency order
-PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
+PHONY += prepare archprepare prepare1 prepare2 prepare3
 
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
-- 
2.20.1



