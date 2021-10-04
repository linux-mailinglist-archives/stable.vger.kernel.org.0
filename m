Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D83420CF2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhJDNKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234812AbhJDNJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD11161B62;
        Mon,  4 Oct 2021 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352586;
        bh=SfoYWOMJcgqUu8FSpG/vTPMGg2RM2y1ihxBzT2hA998=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2W3o2RfmS+AA2ZiXQXr3PasWOqtYzlFbGPxfYNXITLtNGYoM4C37NkhWzudpfX2H
         1PzE7MP7QzN2mLmRaesNI/+2qnWzFNZtPrdqzrwo9yBRuImY7dFNOtgFxvG7pnrp3I
         p9DPitDnYHLVK++RzLsLnH7Ov7wNU2Xqr9zqb/Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Li <ashimida@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/95] arm64: Mark __stack_chk_guard as __ro_after_init
Date:   Mon,  4 Oct 2021 14:52:13 +0200
Message-Id: <20211004125034.989666286@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index d6a49bb07a5f..1945b8096a06 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
-- 
2.33.0



