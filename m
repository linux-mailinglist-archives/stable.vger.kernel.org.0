Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B504A17AD06
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCERN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgCERN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D9E21556;
        Thu,  5 Mar 2020 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428408;
        bh=HGhLDtQYFxY08JXW4Ft/KL+dTQ8RtbcoOb3raUrOpP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNls6EzuFwmsX7O1XayB37TiyWwoJByvq+Jo0gvARAhoAbVn2baMK4IVpV9XDCrMV
         mkBTAI78JsCA9AQWogzwh3yz9S0MqU8ge9eOQ5gB7SzoN2zAUYU5OEzCx7IIjMpUqs
         Cz9zHUYJFrO1kpa/KI6qF22EXMgpxXqQwDy3K5Ys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 13/67] MIPS: cavium_octeon: Fix syncw generation.
Date:   Thu,  5 Mar 2020 12:12:14 -0500
Message-Id: <20200305171309.29118-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 97e914b7de3c943011779b979b8093fdc0d85722 ]

The Cavium Octeon CPU uses a special sync instruction for implementing
wmb, and due to a CPU bug, the instruction must appear twice. A macro
had been defined to hide this:

 #define __SYNC_rpt(type)     (1 + (type == __SYNC_wmb))

which was intended to evaluate to 2 for __SYNC_wmb, and 1 for any other
type of sync. However, this expression is evaluated by the assembler,
and not the compiler, and the result of '==' in the assembler is 0 or
-1, not 0 or 1 as it is in C. The net result was wmb() producing no code
at all. The simple fix in this patch is to change the '+' to '-'.

Fixes: bf92927251b3 ("MIPS: barrier: Add __SYNC() infrastructure")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/sync.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/sync.h b/arch/mips/include/asm/sync.h
index 7c6a1095f5562..aabd097933fe9 100644
--- a/arch/mips/include/asm/sync.h
+++ b/arch/mips/include/asm/sync.h
@@ -155,9 +155,11 @@
  * effective barrier as noted by commit 6b07d38aaa52 ("MIPS: Octeon: Use
  * optimized memory barrier primitives."). Here we specify that the affected
  * sync instructions should be emitted twice.
+ * Note that this expression is evaluated by the assembler (not the compiler),
+ * and that the assembler evaluates '==' as 0 or -1, not 0 or 1.
  */
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
-# define __SYNC_rpt(type)	(1 + (type == __SYNC_wmb))
+# define __SYNC_rpt(type)	(1 - (type == __SYNC_wmb))
 #else
 # define __SYNC_rpt(type)	1
 #endif
-- 
2.20.1

