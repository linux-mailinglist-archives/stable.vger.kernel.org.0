Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E213FDAB0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbhIAMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245174AbhIAMc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62326113C;
        Wed,  1 Sep 2021 12:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499491;
        bh=1kt6C5ihICQFg3sopXYcm7je5MbaFsC2hq4/+bxew+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2efivFDQ/llgLxc+YJwLsYrnnDNw+wY8oMeR77Zv8Yi4k03EpM5xnbCnL7tQqCaV
         P8XGzfr9EBZq+xecD2am6QXra8ruXuT9iTjn/Jf59P/A8XEDX7LcOvEGtnY7b/qTsX
         mrDJFSQC3o+OCiFMf9tLlP4K4gkLC9B5NOL34eas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/48] ARC: Fix CONFIG_STACKDEPOT
Date:   Wed,  1 Sep 2021 14:27:52 +0200
Message-Id: <20210901122253.467703047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



