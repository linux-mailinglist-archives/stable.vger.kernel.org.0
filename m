Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7012E99DE4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391566AbfHVRqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391674AbfHVRW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:57 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C7523406;
        Thu, 22 Aug 2019 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494576;
        bh=G8LchBmt1VAVngPgsDs7T/u2yerKpz+40DXVd0aEkhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcKURPDmWq7FK8pqSs6ZCxU20iUaTpO2E5j3OyOWXRYqV/1qY2/wS9rMwxUexmXnZ
         brkbMGZexCdDOZNKDdw56J86vOv2vAajl17UslEDZwdxSW4+kEmpqSqaXTjdgMC/zm
         +MyvPtjmEwMScbww/NSkfw8FAVyeQi1S8Vc6mzQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.4 67/78] asm-generic: default BUG_ON(x) to if(x)BUG()
Date:   Thu, 22 Aug 2019 10:19:11 -0700
Message-Id: <20190822171833.970801534@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 3c047057d1206ec0f3b88c7809cacba478067a0c upstream.

When CONFIG_BUG is disabled, BUG_ON() will only evaluate the condition,
but will not actually stop the current thread. GCC warns about a couple
of BUG_ON() users where this actually leads to further undefined
behavior:

include/linux/ceph/osdmap.h: In function 'ceph_can_shift_osds':
include/linux/ceph/osdmap.h:54:1: warning: control reaches end of non-void function
fs/ext4/inode.c: In function 'ext4_map_blocks':
fs/ext4/inode.c:548:5: warning: 'retval' may be used uninitialized in this function
drivers/mfd/db8500-prcmu.c: In function 'prcmu_config_clkout':
drivers/mfd/db8500-prcmu.c:762:10: warning: 'div_mask' may be used uninitialized in this function
drivers/mfd/db8500-prcmu.c:769:13: warning: 'mask' may be used uninitialized in this function
drivers/mfd/db8500-prcmu.c:757:7: warning: 'bits' may be used uninitialized in this function
drivers/tty/serial/8250/8250_core.c: In function 'univ8250_release_irq':
drivers/tty/serial/8250/8250_core.c:252:18: warning: 'i' may be used uninitialized in this function
drivers/tty/serial/8250/8250_core.c:235:19: note: 'i' was declared here

There is an obvious conflict of interest here: on the one hand, someone
who disables CONFIG_BUG() will want the kernel to be as small as possible
and doesn't care about printing error messages to a console that nobody
looks at. On the other hand, running into a BUG_ON() condition means that
something has gone wrong, and we probably want to also stop doing things
that might cause data corruption.

This patch picks the second choice, and changes the NOP to BUG(), which
normally stops the execution of the current thread in some form (endless
loop or a trap). This follows the logic we applied in a4b5d580e078 ("bug:
Make BUG() always stop the machine").

For ARM multi_v7_defconfig, the size slightly increases:

section		CONFIG_BUG=y	CONFIG_BUG=n	CONFIG_BUG=n+patch

  .text            8320248   |     8180944   |     8207688
  .rodata          3633720   |     3567144   |     3570648
  __bug_table        32508   |         ---   |         ---
  __modver             692   |        1584   |        2176
  .init.text        558132   |      548300   |      550088
  .exit.text         12380   |       12256   |       12380
  .data            1016672   |     1016064   |     1016128
  Total           14622556   |    14374510   |    14407326

So instead of saving 1.70% of the total image size, we only save 1.48%
by turning off CONFIG_BUG, but in return we can ensure that we don't run
into cases of uninitialized variable or return code uses when something
bad happens. Aside from that, we significantly reduce the number of
warnings in randconfig builds, which makes it easier to fix the warnings
about other problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -143,7 +143,7 @@ extern void warn_slowpath_null(const cha
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while (0)
+#define BUG_ON(condition) do { if (condition) BUG(); } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON


