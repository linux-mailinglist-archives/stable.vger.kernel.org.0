Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3A420C42
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhJDNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234653AbhJDNCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:02:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAACA61425;
        Mon,  4 Oct 2021 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352368;
        bh=HvfpR91yjJvjBk152IC5FGWrsx+wFf6UOvOqNseZ3VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUoYWrgbIF51tZvcXHlR5Os7Z1cAMKOfD+xumoTbHdvAku234R/dl74pxXf/pSrOS
         SYZIyVbcVZWYao/ARbDZtDj6G/7JvTbKGwshEWOGgPNu+HHKMF6akS3cMmA0+gMhGI
         8nkoVk4t9EMYc36p3TWCCaCoxvkVV69CCoFPfV3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/75] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Mon,  4 Oct 2021 14:52:08 +0200
Message-Id: <20211004125032.626298996@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Li <ashimida@linux.alibaba.com>

[ Upstream commit 9fcb2e93f41c07a400885325e7dbdfceba6efaec ]

__stack_chk_guard is setup once while init stage and never changed
after that.

Although the modification of this variable at runtime will usually
cause the kernel to crash (so does the attacker), it should be marked
as __ro_after_init, and it should not affect performance if it is
placed in the ro_after_init section.

Signed-off-by: Dan Li <ashimida@linux.alibaba.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1631612642-102881-1-git-send-email-ashimida@linux.alibaba.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2ff327651ebe..dac14125f8a2 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
-- 
2.33.0



