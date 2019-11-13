Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A445BFA11E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfKMBy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbfKMBy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4379D222D4;
        Wed, 13 Nov 2019 01:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610096;
        bh=WNzOcSDtG5/ZzPIRNc452Bw+G3KZ9d2AoXandGQy9MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O31C+kpZB4sHp8r5M/3LrkKdehhy7EUFcyRVt3+VAkYgcN0Wt9UTWlngUMBaEEBZy
         aHb7jPt7UsAu3rUzyZZn0divSCl7jrMSuOJBxiDclYytQHMDbN8eFDNdIGoPXbkqJQ
         KaU4WyjRlhB64NV2kzkIQqNX2rZ0KjHhORyBBHK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/209] s390/kasan: avoid user access code instrumentation
Date:   Tue, 12 Nov 2019 20:49:34 -0500
Message-Id: <20191113015025.9685-158-sashal@kernel.org>
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

[ Upstream commit b6cbe3e8bdff6f21f1b58b08a55f479cdcf98282 ]

Kasan instrumentation adds "store" check for variables marked as
modified by inline assembly. With user pointers containing addresses
from another address space this produces false positives.

static inline unsigned long clear_user_xc(void __user *to, ...)
{
	asm volatile(
	...
	: "+a" (to) ...

User space access functions are wrapped by manually instrumented
functions in kasan common code, which should be sufficient to catch
errors. So, we just disable uaccess.o instrumentation altogether.

Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 57ab40188d4bd..5418d10dc2a81 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -9,5 +9,9 @@ lib-$(CONFIG_SMP) += spinlock.o
 lib-$(CONFIG_KPROBES) += probes.o
 lib-$(CONFIG_UPROBES) += probes.o
 
+# Instrumenting memory accesses to __user data (in different address space)
+# produce false positives
+KASAN_SANITIZE_uaccess.o := n
+
 chkbss := mem.o
 include $(srctree)/arch/s390/scripts/Makefile.chkbss
-- 
2.20.1

