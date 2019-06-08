Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA23339EDE
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfFHLlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbfFHLlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:41:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 618D8214D8;
        Sat,  8 Jun 2019 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994070;
        bh=KXuYvw3/D0vv9vxod8xwf7/qWzRXSE1mlN6grdo9A7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzoPawAcNxK/JvDK5p99uUz/OIs6QxfVA+PGhT/RiB5L6J+nLbmN0VUfl/kE0TdaX
         9LMQ5Jsjd3ZaXfQgpqIKzAIVujR12U4ImvZuvKMdfoXnI4lHXvPX0IPTtqKbKlCVjv
         1RNigrAjx4nOHBL+JjJqoatWZb5OMZ2nHUXky8gE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kbuild test robot <lkp@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 47/70] ia64: fix build errors by exporting paddr_to_nid()
Date:   Sat,  8 Jun 2019 07:39:26 -0400
Message-Id: <20190608113950.8033-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9a626c4a6326da4433a0d4d4a8a7d1571caf1ed3 ]

Fix build errors on ia64 when DISCONTIGMEM=y and NUMA=y by
exporting paddr_to_nid().

Fixes these build errors:

ERROR: "paddr_to_nid" [sound/core/snd-pcm.ko] undefined!
ERROR: "paddr_to_nid" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "paddr_to_nid" [fs/cifs/cifs.ko] undefined!
ERROR: "paddr_to_nid" [drivers/video/fbdev/core/fb.ko] undefined!
ERROR: "paddr_to_nid" [drivers/usb/mon/usbmon.ko] undefined!
ERROR: "paddr_to_nid" [drivers/usb/core/usbcore.ko] undefined!
ERROR: "paddr_to_nid" [drivers/md/raid1.ko] undefined!
ERROR: "paddr_to_nid" [drivers/md/dm-mod.ko] undefined!
ERROR: "paddr_to_nid" [drivers/md/dm-crypt.ko] undefined!
ERROR: "paddr_to_nid" [drivers/md/dm-bufio.ko] undefined!
ERROR: "paddr_to_nid" [drivers/ide/ide-core.ko] undefined!
ERROR: "paddr_to_nid" [drivers/ide/ide-cd_mod.ko] undefined!
ERROR: "paddr_to_nid" [drivers/gpu/drm/drm.ko] undefined!
ERROR: "paddr_to_nid" [drivers/char/agp/agpgart.ko] undefined!
ERROR: "paddr_to_nid" [drivers/block/nbd.ko] undefined!
ERROR: "paddr_to_nid" [drivers/block/loop.ko] undefined!
ERROR: "paddr_to_nid" [drivers/block/brd.ko] undefined!
ERROR: "paddr_to_nid" [crypto/ccm.ko] undefined!

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/mm/numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/mm/numa.c b/arch/ia64/mm/numa.c
index a03803506b0c..5e1015eb6d0d 100644
--- a/arch/ia64/mm/numa.c
+++ b/arch/ia64/mm/numa.c
@@ -55,6 +55,7 @@ paddr_to_nid(unsigned long paddr)
 
 	return (i < num_node_memblks) ? node_memblk[i].nid : (num_node_memblks ? -1 : 0);
 }
+EXPORT_SYMBOL(paddr_to_nid);
 
 #if defined(CONFIG_SPARSEMEM) && defined(CONFIG_NUMA)
 /*
-- 
2.20.1

