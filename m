Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08A13FDBE3
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343773AbhIAMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345273AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56CFA6120F;
        Wed,  1 Sep 2021 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499901;
        bh=pNEVaHNSTAF9FTtkmNhvWOxrJ8J856+QCpy1TxVkvEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJa9GakYIpbQwDhapRslk1+CGJo2MNHqIe0G6NJPUZTe6SMlU4IcvkKqQgS92NGTN
         mzDku8vqTjZmSRpM53QvqZNAO2DOWUXh+e6Fx5I7CDsZvL4CTY9zhN7HCXacXWgHDZ
         Uu6Bmecx0zNP3MrdsAdqe4ua19n9W0EV8LxilTE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 006/113] ARC: Fix CONFIG_STACKDEPOT
Date:   Wed,  1 Sep 2021 14:27:21 +0200
Message-Id: <20210901122302.184754328@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
index e2146a8da195..529ae50f9fe2 100644
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



