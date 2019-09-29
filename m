Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD0AC16F7
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfI2ReH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730286AbfI2ReF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79AEA21928;
        Sun, 29 Sep 2019 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778445;
        bh=BU1jzN53PqmlJ8ONEqVVq43OmhXY/UNCrwZY04OTspg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDbKSYRh8dDLjeT2bEduwJFOnuyzLl4BFUskq03IaMKxTZPb7Iu/UFLUdrS5YW0AU
         9yL7bNZdjBvvAWVcwDMIiAWPp4gKwwdT66N2uwenpQe1QvwpPnB9b0OgmA92VydS1h
         4fQOdz/SlULwxCqAhMN/0M4sl5V9K/76/GArzojo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Boichat <drinkcat@chromium.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 38/42] kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K
Date:   Sun, 29 Sep 2019 13:32:37 -0400
Message-Id: <20190929173244.8918-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit b751c52bb587ae66f773b15204ef7a147467f4c7 ]

The current default value (400) is too low on many systems (e.g.  some
ARM64 platform takes up 1000+ entries).

syzbot uses 16000 as default value, and has proved to be enough on beefy
configurations, so let's pick that value.

This consumes more RAM on boot (each entry is 160 bytes, so in total
~2.5MB of RAM), but the memory would later be freed (early_log is
__initdata).

Link: http://lkml.kernel.org/r/20190730154027.101525-1-drinkcat@chromium.org
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cbdfae3798965..120ec6f64bbc3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -599,7 +599,7 @@ config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
 	int "Maximum kmemleak early log entries"
 	depends on DEBUG_KMEMLEAK
 	range 200 40000
-	default 400
+	default 16000
 	help
 	  Kmemleak must track all the memory allocations to avoid
 	  reporting false positives. Since memory may be allocated or
-- 
2.20.1

