Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E23EE128
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhHQAhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236496AbhHQAgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A3561075;
        Tue, 17 Aug 2021 00:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160570;
        bh=1kt6C5ihICQFg3sopXYcm7je5MbaFsC2hq4/+bxew+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRmfd1Ce+UGesMk96p6FupBcP4zkxtgwllrr7LNTX6K2j5o6tE0HW1cwYPgslEPoc
         T6pvXQvcyNiCBPCd7UiZMOmZS/W8GLHwMhUsQL0SFMNdfQCJbcb+oM6FZvSgtjOyNm
         G8Ex5BwAO3aJsLAj6nJvSr/xAK8VqzqYebiq2DSMYc0uV8CYbhyw+fg/CbIy6Ud5J8
         rDThODQppEIRvHGGsnVFwkNQgdiVugbu2msU/nmg+4mRU7ZERreGyX1wpCuB7f716h
         OAse2iS3X61TKbggKBJVcCp7ZLQ9iRtQ+mIP64VPMRErcmfsZkDPmwdB+hLOuwdOeI
         Yp9qrWpTvFtlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 2/5] ARC: Fix CONFIG_STACKDEPOT
Date:   Mon, 16 Aug 2021 20:36:04 -0400
Message-Id: <20210817003607.83340-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003607.83340-1-sashal@kernel.org>
References: <20210817003607.83340-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit bf79167fd86f3b97390fe2e70231d383526bd9cc ]

Enabling CONFIG_STACKDEPOT results in the following build error.

arc-elf-ld: lib/stackdepot.o: in function `filter_irq_stacks':
stackdepot.c:(.text+0x456): undefined reference to `__irqentry_text_start'
arc-elf-ld: stackdepot.c:(.text+0x456): undefined reference to `__irqentry_text_start'
arc-elf-ld: stackdepot.c:(.text+0x476): undefined reference to `__irqentry_text_end'
arc-elf-ld: stackdepot.c:(.text+0x476): undefined reference to `__irqentry_text_end'
arc-elf-ld: stackdepot.c:(.text+0x484): undefined reference to `__softirqentry_text_start'
arc-elf-ld: stackdepot.c:(.text+0x484): undefined reference to `__softirqentry_text_start'
arc-elf-ld: stackdepot.c:(.text+0x48c): undefined reference to `__softirqentry_text_end'
arc-elf-ld: stackdepot.c:(.text+0x48c): undefined reference to `__softirqentry_text_end'

Other architectures address this problem by adding IRQENTRY_TEXT and
SOFTIRQENTRY_TEXT to the text segment, so do the same here.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index 6c693a9d29b6..0391b8293ad8 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -88,6 +88,8 @@ SECTIONS
 		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 	}
-- 
2.30.2

