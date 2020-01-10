Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DB3137953
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgAJWHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgAJWHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:07:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC692072E;
        Fri, 10 Jan 2020 22:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578694043;
        bh=Q5653fpa3ijpZTYcOhg1IEB8ey1XF1cto6FMBRl6nvo=;
        h=From:To:Cc:Subject:Date:From;
        b=DfXFcVeBJkbjTcTUUwvB51i1rCeHrHF4gCyMfTT5M1eLh8jl6kHnXcR+o5jP0qog8
         FTBxPnLZ4fRVNKg8kR5UUAFotQbuEgbK8lF9MRxAkEltaHMVfTxgaeDGsVPLlBv27Y
         Xy4HHlebEG92f1rqpIUk0BM/3frtSZ8qm9GprTLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Paul Burton <paulburton@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 1/6] MIPS: Prevent link failure with kcov instrumentation
Date:   Fri, 10 Jan 2020 17:07:16 -0500
Message-Id: <20200110220721.28780-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit a4a3893114a41e365274d5fab5d9ff5acc235ff0 ]

__sanitizer_cov_trace_pc() is not linked in and causing link
failure if KCOV_INSTRUMENT is enabled. Fix this by disabling
instrumentation for compressed image.

Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index ad31c76c7a29..2f77e250b91d 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -29,6 +29,9 @@ KBUILD_AFLAGS := $(LINUXINCLUDE) $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) \
 	-DKERNEL_ENTRY=$(VMLINUX_ENTRY_ADDRESS)
 
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT		:= n
+
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
 
-- 
2.20.1

