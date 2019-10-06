Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A45CD4FA
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfJFRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729364AbfJFRbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB272087E;
        Sun,  6 Oct 2019 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383067;
        bh=LbLyWpx1LAX4yaF3lZ06T0Ps5gzxnKDuVca7dt58IrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBlnZwn8onX23s8gMAgMCKPAQytdDtIkuYP4CQgQqE3T5oV+hSJbaAPT4RfbxX4We
         9QLOhwX7Q3TW1oZDW2Y63pH1IfLdJw5W+BiX5hE216w9clWMeSTdthOR+zJw9d38dH
         ju/AGppFHxzsmsGyPuPZSHYBoltuIE9+1YbLi2vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
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
Subject: [PATCH 4.19 073/106] kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K
Date:   Sun,  6 Oct 2019 19:21:19 +0200
Message-Id: <20191006171153.881465237@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3dea52f7be9c1..46a910acce3f0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -570,7 +570,7 @@ config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
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



