Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044983CD8DB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbhGSOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243561AbhGSOYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6BBE6124B;
        Mon, 19 Jul 2021 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707034;
        bh=VDn8Lf76RE6bwRYg4ASwwlWSFYqZM+D7FfaQchqCbJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/XP/qKxZu0bm3uSKN+tW+sUKRrM4Ji3IOFo3CWr+U+sxFNk7wMACXrEyIRctw54+
         DakiqGE6ZhRuWdZh16vW0rS1FY0P/9ODL8mCGVi7myqximN7YQ1ycvHHJ7EvDLvf0c
         EzWQlkHo79nlLdHQivzHdyVp22yMvRjMkZwnvKIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Kyungsik Lee <kyungsik.lee@lge.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 187/188] mips: disable branch profiling in boot/decompress.o
Date:   Mon, 19 Jul 2021 16:52:51 +0200
Message-Id: <20210719144942.609613328@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 97e488073cfca0eea84450169ca4cbfcc64e33e3 ]

Use DISABLE_BRANCH_PROFILING for arch/mips/boot/compressed/decompress.o
to prevent linkage errors.

mips64-linux-ld: arch/mips/boot/compressed/decompress.o: in function `LZ4_decompress_fast_extDict':
decompress.c:(.text+0x8c): undefined reference to `ftrace_likely_update'
mips64-linux-ld: decompress.c:(.text+0xf4): undefined reference to `ftrace_likely_update'
mips64-linux-ld: decompress.c:(.text+0x200): undefined reference to `ftrace_likely_update'
mips64-linux-ld: decompress.c:(.text+0x230): undefined reference to `ftrace_likely_update'
mips64-linux-ld: decompress.c:(.text+0x320): undefined reference to `ftrace_likely_update'
mips64-linux-ld: arch/mips/boot/compressed/decompress.o:decompress.c:(.text+0x3f4): more undefined references to `ftrace_likely_update' follow

Fixes: e76e1fdfa8f8 ("lib: add support for LZ4-compressed kernel")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/decompress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compressed/decompress.c
index 080cd53bac36..a1a54a3af03b 100644
--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -11,6 +11,8 @@
  * option) any later version.
  */
 
+#define DISABLE_BRANCH_PROFILING
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-- 
2.30.2



