Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D844214BA63
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgA1OSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730692AbgA1OSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:18:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B75B2071E;
        Tue, 28 Jan 2020 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221111;
        bh=BUju0Wx30sPMwP56BcCcBb6OikCck+XYZB+oJtZUH1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF0a7LctiJvF+msgA5UZfkfAosWqbu++CAHy0wDpVnBzabXq4ja4lTp5inM4ZqSlo
         +JHNc1UC2RZuYwIAr8OXj19D5zUyFOwIbdGCbUAS752i5t/8yIYq+5SCgu5SG6Whof
         X5DxmVzv6mW0ayRmsv1bTNozPGX6doS4WjBd539g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Ley Foon Tan <ley.foon.tan@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/271] nios2: ksyms: Add missing symbol exports
Date:   Tue, 28 Jan 2020 15:04:02 +0100
Message-Id: <20200128135859.516344561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0f8ed994575429d6042cf5d7ef70081c94091587 ]

Building nios2:allmodconfig fails as follows (each symbol is only listed
once).

ERROR: "__ashldi3" [drivers/md/dm-writecache.ko] undefined!
ERROR: "__ashrdi3" [fs/xfs/xfs.ko] undefined!
ERROR: "__ucmpdi2" [drivers/media/i2c/adv7842.ko] undefined!
ERROR: "__lshrdi3" [drivers/md/dm-zoned.ko] undefined!
ERROR: "flush_icache_range" [drivers/misc/lkdtm/lkdtm.ko] undefined!
ERROR: "empty_zero_page" [drivers/md/dm-mod.ko] undefined!

The problem is seen with gcc 7.3.0.

Export the missing symbols.

Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/nios2_ksyms.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/nios2/kernel/nios2_ksyms.c b/arch/nios2/kernel/nios2_ksyms.c
index bf2f55d10a4d8..4e704046a150c 100644
--- a/arch/nios2/kernel/nios2_ksyms.c
+++ b/arch/nios2/kernel/nios2_ksyms.c
@@ -9,12 +9,20 @@
 #include <linux/export.h>
 #include <linux/string.h>
 
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+
 /* string functions */
 
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memmove);
 
+/* memory management */
+
+EXPORT_SYMBOL(empty_zero_page);
+EXPORT_SYMBOL(flush_icache_range);
+
 /*
  * libgcc functions - functions that are used internally by the
  * compiler...  (prototypes are not correct though, but that
@@ -31,3 +39,7 @@ DECLARE_EXPORT(__udivsi3);
 DECLARE_EXPORT(__umoddi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__ucmpdi2);
+DECLARE_EXPORT(__lshrdi3);
+DECLARE_EXPORT(__ashldi3);
+DECLARE_EXPORT(__ashrdi3);
-- 
2.20.1



