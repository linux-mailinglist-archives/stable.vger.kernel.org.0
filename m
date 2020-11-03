Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0385D2A55ED
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbgKCVEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387934AbgKCVEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:04:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A332F20658;
        Tue,  3 Nov 2020 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437442;
        bh=LND++4XR3EDR/llUZ/t8Jtx2aEsw7I0RX4Po+K4Hwq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dgz9TTtlB4KH2tc8LRm7uNoRuWi3PWGJ+YSkFqEoiTys8Yprp7Eolk88IVAQeBkWh
         UVQT/6sV5D+4lxxb+YkogYdmZqH+Hg5EP6j3iVGRELsrgn+G9VfkKoRqfN8EqaR7nF
         Mxp7hBKJ+HiDUSXaFg9Q3AAtxegk2m/r+pOWdhXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/191] printk: reduce LOG_BUF_SHIFT range for H8300
Date:   Tue,  3 Nov 2020 21:36:09 +0100
Message-Id: <20201103203241.485937166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 47035b5a46f64..5eb91dde4018c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -535,7 +535,8 @@ config IKCONFIG_PROC
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
-	range 12 25
+	range 12 25 if !H8300
+	range 12 19 if H8300
 	default 17
 	depends on PRINTK
 	help
-- 
2.27.0



