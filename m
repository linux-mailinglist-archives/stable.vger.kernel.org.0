Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8674815F4AF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390680AbgBNSXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBNPtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21FD12467C;
        Fri, 14 Feb 2020 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695364;
        bh=riP2gCnJQ9qVck/TvSGiTv6mMO+xMxqF/8NwkLVdcj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EugivuBG698vSvQkbsKbqzKI3WdzpLx8KKsWxXibXF4O9Ek1f2nQPs08V6al2R425
         0l00wHYsKM7QK2PZtg4tXD8I0ietY+jg68gor8OEW39p3JeDyHKHiMTocq3I8rVKGX
         T+sZnQPcsgJswecAx5mTpBQlDXr1uFPCIjZFwa78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.5 023/542] tools/power/acpi: fix compilation error
Date:   Fri, 14 Feb 2020 10:40:15 -0500
Message-Id: <20200214154854.6746-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

[ Upstream commit 1985f8c7f9a42a651a9750d6fcadc74336d182df ]

If we compile tools/acpi target in the top source directory, we'd get a
compilation error showing as bellow:

	# make tools/acpi
	  DESCEND  power/acpi
	  DESCEND  tools/acpidbg
	  CC       tools/acpidbg/acpidbg.o
	Assembler messages:
	Fatal error: can't create /home/lzy/kernel-upstream/power/acpi/\
			tools/acpidbg/acpidbg.o: No such file or directory
	../../Makefile.rules:26: recipe for target '/home/lzy/kernel-upstream/\
			power/acpi/tools/acpidbg/acpidbg.o' failed
	make[3]: *** [/home/lzy/kernel-upstream//power/acpi/tools/acpidbg/\
			acpidbg.o] Error 1
	Makefile:19: recipe for target 'acpidbg' failed
	make[2]: *** [acpidbg] Error 2
	Makefile:54: recipe for target 'acpi' failed
	make[1]: *** [acpi] Error 2
	Makefile:1607: recipe for target 'tools/acpi' failed
	make: *** [tools/acpi] Error 2

Fixes: d5a4b1a540b8 ("tools/power/acpi: Remove direct kernel source include reference")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/acpi/Makefile.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/acpi/Makefile.config b/tools/power/acpi/Makefile.config
index 0111d246d1ca2..54a2857c2510a 100644
--- a/tools/power/acpi/Makefile.config
+++ b/tools/power/acpi/Makefile.config
@@ -15,7 +15,7 @@ include $(srctree)/../../scripts/Makefile.include
 
 OUTPUT=$(srctree)/
 ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/power/acpi/
+	OUTPUT := $(O)/tools/power/acpi/
 endif
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 
-- 
2.20.1

