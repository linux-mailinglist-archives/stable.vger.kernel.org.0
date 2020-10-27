Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E5299EE3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437598AbgJ0ASd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439155AbgJ0AKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E73021D42;
        Tue, 27 Oct 2020 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757411;
        bh=oigTDCXIbkaibd8Qew1xaknkpidrqIl2h5cM3NGG7BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReiI7qJBdp+U8lxEtGnW8uB9JoTfoF4cmZkOWI+hl+tRYxvzIQpfaw/ETZeuhTnLk
         KNcbg80vUPlF4EnR055mvn80xkJ6tzlkzsD9qqzdmcnIGAJ6E9DB3FrpFjvJec8KB9
         benF+T4Uh10aoU+xp3EreuoXUnmBy1kjd7eP3MNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Ogness <john.ogness@linutronix.de>,
        kernel test robot <lkp@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 20/46] printk: reduce LOG_BUF_SHIFT range for H8300
Date:   Mon, 26 Oct 2020 20:09:19 -0400
Message-Id: <20201027000946.1026923-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 550c10d28d21bd82a8bb48debbb27e6ed53262f6 ]

The .bss section for the h8300 is relatively small. A value of
CONFIG_LOG_BUF_SHIFT that is larger than 19 will create a static
printk ringbuffer that is too large. Limit the range appropriately
for the H8300.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20200812073122.25412-1-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 46075327c165d..20f709ea1eb38 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -500,7 +500,8 @@ config IKCONFIG_PROC
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
-	range 12 25
+	range 12 25 if !H8300
+	range 12 19 if H8300
 	default 17
 	depends on PRINTK
 	help
-- 
2.25.1

