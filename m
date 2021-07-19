Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9DF3CDFF0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345196AbhGSPMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344896AbhGSPLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA2FB60FDA;
        Mon, 19 Jul 2021 15:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709904;
        bh=jg9+WrGqWJ2SqvBAU7KcPrIyvo6uHxgYZt05DuCXvqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFvUMBbmGHrYPiG0463l6nMvaW3LGJIr8ZmR3iVK/Ar6yTR+Ds6dD60bOZjsoLMe5
         hKehMCHqgKfWWm+kKY1EWrIP7mibGFf/Uiau8qilX/o4zvyzliW5tLyTd37ELAt61P
         accU4lsTEQi2aoCbAX9tKILh93JR3UrdKCIaTlrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Kyungsik Lee <kyungsik.lee@lge.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/149] mips: disable branch profiling in boot/decompress.o
Date:   Mon, 19 Jul 2021 16:54:13 +0200
Message-Id: <20210719144935.596994577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index a52e929381ea..281e922e5c65 100644
--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -7,6 +7,8 @@
  * Author: Wu Zhangjin <wuzhangjin@gmail.com>
  */
 
+#define DISABLE_BRANCH_PROFILING
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-- 
2.30.2



