Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94FBAA8D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfIVT2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404323AbfIVSu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E073208C2;
        Sun, 22 Sep 2019 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178256;
        bh=ifZ3V7ZCH5w23cboU3vYYYsrlUpjnatzjxURontzwQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFu3jD7jCbthEbQlap9Xo2K1n1BmPerIwkIrf7C0nSvSRAoWQ/QOX/D29YOmYM25J
         o6j7W3GrO8VsEQYrkbTyXqYil30EsxYlYIbfCgSjE9U9udMmzy8G9BWaBJBTAH4byO
         wTVADzUTuXCf4i1xlFLcrN1C6bmqfOmaiHnGd+kg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 046/185] RAS: Fix prototype warnings
Date:   Sun, 22 Sep 2019 14:47:04 -0400
Message-Id: <20190922184924.32534-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valdis Klētnieks <valdis.kletnieks@vt.edu>

[ Upstream commit 0a54b809a3a2c31e1055b45b03708eb730222be1 ]

When building with C=2 and/or W=1, legitimate warnings are issued about
missing prototypes:

    CHECK   drivers/ras/debugfs.c
  drivers/ras/debugfs.c:4:15: warning: symbol 'ras_debugfs_dir' was not declared. Should it be static?
  drivers/ras/debugfs.c:8:5: warning: symbol 'ras_userspace_consumers' was not declared. Should it be static?
  drivers/ras/debugfs.c:38:12: warning: symbol 'ras_add_daemon_trace' was not declared. Should it be static?
  drivers/ras/debugfs.c:54:13: warning: symbol 'ras_debugfs_init' was not declared. Should it be static?
    CC      drivers/ras/debugfs.o
  drivers/ras/debugfs.c:8:5: warning: no previous prototype for 'ras_userspace_consumers' [-Wmissing-prototypes]
      8 | int ras_userspace_consumers(void)
        |     ^~~~~~~~~~~~~~~~~~~~~~~
  drivers/ras/debugfs.c:38:12: warning: no previous prototype for 'ras_add_daemon_trace' [-Wmissing-prototypes]
     38 | int __init ras_add_daemon_trace(void)
        |            ^~~~~~~~~~~~~~~~~~~~
  drivers/ras/debugfs.c:54:13: warning: no previous prototype for 'ras_debugfs_init' [-Wmissing-prototypes]
     54 | void __init ras_debugfs_init(void)
        |             ^~~~~~~~~~~~~~~~

Provide the proper includes.

 [ bp: Take care of the same warnings for cec.c too. ]

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/7168.1565218769@turing-police
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ras/cec.c     | 1 +
 drivers/ras/debugfs.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index f5795adc5a6e1..8037c490f3ba7 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/ras.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
 
diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
index 9c1b717efad86..0d4f985afbf37 100644
--- a/drivers/ras/debugfs.c
+++ b/drivers/ras/debugfs.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/debugfs.h>
+#include <linux/ras.h>
+#include "debugfs.h"
 
 struct dentry *ras_debugfs_dir;
 
-- 
2.20.1

