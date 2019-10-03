Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24CFDCA39A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfJCQRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbfJCQRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C169720700;
        Thu,  3 Oct 2019 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119423;
        bh=i5xIGvAmJ611D+9rinA4VEpsJYMNIu3CSB0dALNOkD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgB5l1iLP0HuF/FNGYCUrc5S7NMKATNUijs0vXfz0nazGGVOKe9dHpziS3pSPfMN8
         fbQeuOGJObFCg9l1/x89ZV4ojOYlzxNSt4uk/EZ8B5IEEcjXLaf7hLqmqXzqzQfhn+
         YrZcOMkOG2Boi3+m924Y+ciDL6krAQRBuGMN8nEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/211] RAS: Fix prototype warnings
Date:   Thu,  3 Oct 2019 17:52:04 +0200
Message-Id: <20191003154501.432687344@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index 5d2b2c02cbbec..0c719787876a5 100644
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
index 501603057dffe..12a161377f4f8 100644
--- a/drivers/ras/debugfs.c
+++ b/drivers/ras/debugfs.c
@@ -1,4 +1,6 @@
 #include <linux/debugfs.h>
+#include <linux/ras.h>
+#include "debugfs.h"
 
 struct dentry *ras_debugfs_dir;
 
-- 
2.20.1



