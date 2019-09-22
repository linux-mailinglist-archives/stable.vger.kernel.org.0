Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2648BA67D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404597AbfIVSu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404446AbfIVSu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A3021D6C;
        Sun, 22 Sep 2019 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178257;
        bh=CiyScJoSbjEh1dk6sz0/OoVDGfhZZEA9aBDwuupZISg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r/gi9PSWDQBt/I4yKAskRywb2n+ffK+XcQIERFs1fZpy8ZPAIXnb/m/ubt1MNSvH
         WMZnMIn1B/+vlBiLAnPV7VVCAvOWJAfdQ85QYbWNqEs21CP/ICVTzmO9g51vkvAZAu
         UAGr7VfNACCViE0M7yokmox68qL1AQInDjDw0K5Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        kbuild test robot <lkp@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 047/185] RAS: Build debugfs.o only when enabled in Kconfig
Date:   Sun, 22 Sep 2019 14:47:05 -0400
Message-Id: <20190922184924.32534-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

[ Upstream commit b6ff24f7b5101101ff897dfdde3f37924e676bc2 ]

In addition, the 0day bot reported this build error:

  >> drivers/ras/debugfs.c:10:5: error: redefinition of 'ras_userspace_consumers'
      int ras_userspace_consumers(void)
          ^~~~~~~~~~~~~~~~~~~~~~~
     In file included from drivers/ras/debugfs.c:3:0:
     include/linux/ras.h:14:19: note: previous definition of 'ras_userspace_consumers' was here
      static inline int ras_userspace_consumers(void) { return 0; }
                      ^~~~~~~~~~~~~~~~~~~~~~~

for a riscv-specific .config where CONFIG_DEBUG_FS is not set. Fix all
that by making debugfs.o depend on that define.

 [ bp: Rewrite commit message. ]

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/7053.1565218556@turing-police
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ras/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
index ef6777e14d3df..6f0404f501071 100644
--- a/drivers/ras/Makefile
+++ b/drivers/ras/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_RAS)	+= ras.o debugfs.o
+obj-$(CONFIG_RAS)	+= ras.o
+obj-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_RAS_CEC)	+= cec.o
-- 
2.20.1

