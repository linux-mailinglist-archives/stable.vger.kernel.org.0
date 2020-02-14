Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8915EFE9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388217AbgBNRvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbgBNP6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4811E24691;
        Fri, 14 Feb 2020 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695933;
        bh=4xz8fuR2XJP3Un2ldiH769b+k8BXaoSjCq8w1wOO9rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESDfs5LuoosnDlBRBp9xSOSGrhRrdVlCa5ZZjNCeL/WJMEIaauILEp+d+SjesA+qZ
         PBIECOWoGf86M3cYJqNvqIYfujjbnZXAAE8bj4nfw148PhnUjXRBKs7GjfCkibV07D
         nuam/VzQAks6DggdDnBJyUt+iyF7HC+Gt6qjzR9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 468/542] ARM: 8951/1: Fix Kexec compilation issue.
Date:   Fri, 14 Feb 2020 10:47:40 -0500
Message-Id: <20200214154854.6746-468-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 76950f7162cad51d2200ebd22c620c14af38f718 ]

To perform the reserve_crashkernel() operation kexec uses SECTION_SIZE to
find a memblock in a range.
SECTION_SIZE is not defined for nommu systems. Trying to compile kexec in
these conditions results in a build error:

  linux/arch/arm/kernel/setup.c: In function ‘reserve_crashkernel’:
  linux/arch/arm/kernel/setup.c:1016:25: error: ‘SECTION_SIZE’ undeclared
     (first use in this function); did you mean ‘SECTIONS_WIDTH’?
             crash_size, SECTION_SIZE);
                         ^~~~~~~~~~~~
                         SECTIONS_WIDTH
  linux/arch/arm/kernel/setup.c:1016:25: note: each undeclared identifier
     is reported only once for each function it appears in
  linux/scripts/Makefile.build:265: recipe for target 'arch/arm/kernel/setup.o'
     failed

Make KEXEC depend on MMU to fix the compilation issue.

Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3a9fd05f571..7ef1916fcbf45 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1905,7 +1905,7 @@ config XIP_DEFLATED_DATA
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
 	depends on (!SMP || PM_SLEEP_SMP)
-	depends on !CPU_V7M
+	depends on MMU
 	select KEXEC_CORE
 	help
 	  kexec is a system call that implements the ability to shutdown your
-- 
2.20.1

