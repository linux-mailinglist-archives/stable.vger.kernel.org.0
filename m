Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35B41016C6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfKSFyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732089AbfKSFx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:53:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C323D20885;
        Tue, 19 Nov 2019 05:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142838;
        bh=8DD4osZh3pqSw/v3Z8lBeKCbS7/Ml7qR65jLNRSZyrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q96bbmjN7Y3bMEayGT38i+bj+t5KcfW0GGsmjbsolXUa8uur0Er/UaKRIXLRNLK/A
         V5jDtq59YjapbE8zkNNy3snAOAp1r1uEiivLYMG/d/G8i5PPLVd6MIcnr4jDBe7Msr
         TrVbbkpv6fZ9O03UxNekvyH0KhYqdcVlFt79vZ3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rachel Mozes <rachel.mozes@intel.com>,
        Dengcheng Zhu <dzhu@wavecomp.com>,
        Paul Burton <paul.burton@mips.com>, pburton@wavecomp.com,
        ralf@linux-mips.org, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 177/239] MIPS: kexec: Relax memory restriction
Date:   Tue, 19 Nov 2019 06:19:37 +0100
Message-Id: <20191119051334.361017208@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dengcheng Zhu <dzhu@wavecomp.com>

[ Upstream commit a6da4d6fdf8bd512c98d3ac7f1d16bc4bb282919 ]

We can rely on the system kernel and the dump capture kernel themselves in
memory usage.

Being restrictive with 512MB limit may cause kexec tool failure on some
platforms.

Tested-by: Rachel Mozes <rachel.mozes@intel.com>
Reported-by: Rachel Mozes <rachel.mozes@intel.com>
Signed-off-by: Dengcheng Zhu <dzhu@wavecomp.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/20568/
Cc: pburton@wavecomp.com
Cc: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/kexec.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/kexec.h b/arch/mips/include/asm/kexec.h
index 493a3cc7c39ad..cfdbe66575f4d 100644
--- a/arch/mips/include/asm/kexec.h
+++ b/arch/mips/include/asm/kexec.h
@@ -12,11 +12,11 @@
 #include <asm/stacktrace.h>
 
 /* Maximum physical address we can use pages from */
-#define KEXEC_SOURCE_MEMORY_LIMIT (0x20000000)
+#define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
 /* Maximum address we can reach in physical address mode */
-#define KEXEC_DESTINATION_MEMORY_LIMIT (0x20000000)
+#define KEXEC_DESTINATION_MEMORY_LIMIT (-1UL)
  /* Maximum address we can use for the control code buffer */
-#define KEXEC_CONTROL_MEMORY_LIMIT (0x20000000)
+#define KEXEC_CONTROL_MEMORY_LIMIT (-1UL)
 /* Reserve 3*4096 bytes for board-specific info */
 #define KEXEC_CONTROL_PAGE_SIZE (4096 + 3*4096)
 
-- 
2.20.1



