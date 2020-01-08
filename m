Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71273134BBA
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgAHTqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43540 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730429AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oT-Rp; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dmT-Ua; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Will Deacon" <will.deacon@arm.com>,
        "Yury Norov" <ynorov@caviumnetworks.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:23 +0000
Message-ID: <lsq.1578512578.257521352@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 25/63] arm64: fix COMPAT_SHMLBA definition for large
 pages
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <ynorov@caviumnetworks.com>

commit b9b7aebb42d1b1392f3111de61136bb6cf3aae3f upstream.

ARM glibc uses (4 * __getpagesize()) for SHMLBA, which is correct for
4KB pages and works fine for 64KB pages, but the kernel uses a hardcoded
16KB that is too small for 64KB page based kernels. This changes the
definition to what user space sees when using 64KB pages.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/include/asm/shmparam.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/shmparam.h
+++ b/arch/arm64/include/asm/shmparam.h
@@ -21,7 +21,7 @@
  * alignment value. Since we don't have aliasing D-caches, the rest of
  * the time we can safely use PAGE_SIZE.
  */
-#define COMPAT_SHMLBA	0x4000
+#define COMPAT_SHMLBA	(4 * PAGE_SIZE)
 
 #include <asm-generic/shmparam.h>
 

