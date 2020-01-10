Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E451378D8
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgAJWDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbgAJWDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:03:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F082082E;
        Fri, 10 Jan 2020 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693794;
        bh=7SrXtY3zhTAIs5OpgjwMMDDZzdGmV1xifK4ax0OnMDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFuhvM3nsvNvlFkyPMZ+qUldb/kJ6X8nWN5xH+yUASL7cnXpVd8Fn4dCd8zQX35c0
         /plHbuhsWhm/V5SBGCYMoM+zqN8a0hEzBbN5rge2G+fWs6HAEZfk65wlSWSugMq2et
         t19sRRuu/zsrcdzzXzYmT7tRJE6S53sq7Jxrb7jA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        Paul Burton <paulburton@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 04/26] MIPS: Prevent link failure with kcov instrumentation
Date:   Fri, 10 Jan 2020 17:02:46 -0500
Message-Id: <20200110220308.27784-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220308.27784-1-sashal@kernel.org>
References: <20200110220308.27784-1-sashal@kernel.org>
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
index 172801ed35b8..d859f079b771 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -29,6 +29,9 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) \
 	-DKERNEL_ENTRY=$(VMLINUX_ENTRY_ADDRESS)
 
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT		:= n
+
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
 
-- 
2.20.1

