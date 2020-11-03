Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8E62A5567
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbgKCVJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387859AbgKCVJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0A922226;
        Tue,  3 Nov 2020 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437792;
        bh=8l1TOQkSZjofUoqRSADL9M2CuMYDRzIbYVrUV+XkbeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2MFzoc2Hfx3fFHz9ATk8cbr8z0FPKcZYjlhurJvIkNfLtws+g57pM7OkKJ2ITwqd
         7bj3Ch47Jr9xAMdGmyBXKpzNJsHOLD8NYSg/Jl9r/DjAm5dzu8qMZoe/rBGnkWeI1j
         rfZ9CWmkWxPiEKvT15lkguVetkmYnOzvwxwD6bkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/125] printk: reduce LOG_BUF_SHIFT range for H8300
Date:   Tue,  3 Nov 2020 21:36:52 +0100
Message-Id: <20201103203202.121258838@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
2.27.0



