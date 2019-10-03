Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E998ACA889
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391376AbfJCQ2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391399AbfJCQ2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:28:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DE82054F;
        Thu,  3 Oct 2019 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120095;
        bh=ifZ3V7ZCH5w23cboU3vYYYsrlUpjnatzjxURontzwQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShcKZ7A69GVCUkXzNEnaGjggn7d3fhRPmDtkfg7luYE+Z7miFQM+Or9DsFhsrj6MA
         tGVlC7tDr5JjODKCHb0H07qIh9zYWsBV3dfe540zrp+unbO+vHhGIKEnaWdsYleLWj
         gjBNKPEAvcsj5qu6N/+8ofe0VMg98SSONFaTrhNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 078/313] RAS: Fix prototype warnings
Date:   Thu,  3 Oct 2019 17:50:56 +0200
Message-Id: <20191003154540.526612763@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
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



