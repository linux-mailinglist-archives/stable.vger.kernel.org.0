Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378362D9FDA
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408792AbgLNTA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502190AbgLNRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 036/105] zlib: export S390 symbols for zlib modules
Date:   Mon, 14 Dec 2020 18:28:10 +0100
Message-Id: <20201214172557.017083640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 11fb479ff5d9872ddff02dd533c16d60372c86b2 ]

Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
by exporting the 2 needed symbols in dfltcc_inflate.c.

Fixes these build errors:

  ERROR: modpost: "dfltcc_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
  ERROR: modpost: "dfltcc_can_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!

Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lkml.kernel.org/r/20201123191712.4882-1-rdunlap@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zlib_dfltcc/dfltcc_inflate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/zlib_dfltcc/dfltcc_inflate.c b/lib/zlib_dfltcc/dfltcc_inflate.c
index aa9ef23474df0..db107016d29b3 100644
--- a/lib/zlib_dfltcc/dfltcc_inflate.c
+++ b/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -4,6 +4,7 @@
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 #include <asm/setup.h>
+#include <linux/export.h>
 #include <linux/zutil.h>
 
 /*
@@ -29,6 +30,7 @@ int dfltcc_can_inflate(
     return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
                is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
 }
+EXPORT_SYMBOL(dfltcc_can_inflate);
 
 static int dfltcc_was_inflate_used(
     z_streamp strm
@@ -147,3 +149,4 @@ dfltcc_inflate_action dfltcc_inflate(
     return (cc == DFLTCC_CC_OP1_TOO_SHORT || cc == DFLTCC_CC_OP2_TOO_SHORT) ?
         DFLTCC_INFLATE_BREAK : DFLTCC_INFLATE_CONTINUE;
 }
+EXPORT_SYMBOL(dfltcc_inflate);
-- 
2.27.0



