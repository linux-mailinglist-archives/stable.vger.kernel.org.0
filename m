Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDAEFA118
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfKMByu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbfKMByt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21028222CF;
        Wed, 13 Nov 2019 01:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610088;
        bh=3V4B+5FPwQ+goJN1+z1cIB2n93aSNpU3SDah4sLezHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mlw66dZib48NUZyiIoYPnyGQpg8jIbJCWMnv06PpaKQWx36bmpSIyPZWbdT4zhv35
         +Nwyf/JE2JKCb8btoduGDNlwcokeDytqfGN3OLlAeFJFaQIdMyURC51M715lpJVgZM
         zR+TvKEIYhavGRXV3wDO5jRzW6XsZ+y5WSfvaJ+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 156/209] s390/kasan: avoid vdso instrumentation
Date:   Tue, 12 Nov 2019 20:49:32 -0500
Message-Id: <20191113015025.9685-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 348498458505e202df41b6b9a78da448d39298b7 ]

vdso is mapped into user space processes, which won't have kasan
shodow mapped.

Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 3 ++-
 arch/s390/kernel/vdso64/Makefile | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index 04dd3e2c3bd9b..e76309fbbcb3b 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -28,9 +28,10 @@ obj-y += vdso32_wrapper.o
 extra-y += vdso32.lds
 CPPFLAGS_vdso32.lds += -P -C -U$(ARCH)
 
-# Disable gcov profiling and ubsan for VDSO code
+# Disable gcov profiling, ubsan and kasan for VDSO code
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
 
 # Force dependency (incbin is bad)
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index ddebc26cd9494..f849ac61c5da0 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -28,9 +28,10 @@ obj-y += vdso64_wrapper.o
 extra-y += vdso64.lds
 CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 
-# Disable gcov profiling and ubsan for VDSO code
+# Disable gcov profiling, ubsan and kasan for VDSO code
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
+KASAN_SANITIZE := n
 
 # Force dependency (incbin is bad)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
-- 
2.20.1

