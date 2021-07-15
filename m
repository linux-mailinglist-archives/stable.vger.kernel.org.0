Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F883C9EA2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhGOMdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:33:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6938 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhGOMdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:33:16 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQYX64bCWz7v8D;
        Thu, 15 Jul 2021 20:26:46 +0800 (CST)
Received: from huawei.com (100.120.247.70) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Jul 2021 20:30:20 +0800
From:   Liang Wang <wangliang101@huawei.com>
To:     <palmerdabbelt@google.com>, <mcgrof@kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux@armlinux.org.uk>
CC:     <stable@vger.kernel.org>, <wangliang101@huawei.com>,
        <wangle6@huawei.com>, <kepler.chenxin@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH] arm:mmap: fix physical address overflow when CONFIG_ARM_LPAE=y
Date:   Thu, 15 Jul 2021 20:30:12 +0800
Message-ID: <20210715123012.61215-1-wangliang101@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [100.120.247.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the CONFIG_ARM_LPAE is enabled on arm32, the physical address may
exceed 32 bits. In the devmem_is_allowed function, the physical address
is obtained through displacement of the physical page number.Without
explicit translation, the physical address may overflow and be truncated.
Use the PFN_PHYS macro to fix this bug.

This bug was initially introduced in v2.6.37 with commit:087aaffcdf9c91.
In v5.10, this code has been modified by commit:527701eda5f196.

Fixes: 527701eda5f196 ("lib: Add a generic version of devmem_is_allowed")
Fixes: 087aaffcdf9c91 ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
Cc: stable@vger.kernel.org # v2.6.37
Signed-off-by: Liang Wang <wangliang101@huawei.com>
---
 lib/devmem_is_allowed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devmem_is_allowed.c b/lib/devmem_is_allowed.c
index c0d67c541849..60be9e24bd57 100644
--- a/lib/devmem_is_allowed.c
+++ b/lib/devmem_is_allowed.c
@@ -19,7 +19,7 @@
  */
 int devmem_is_allowed(unsigned long pfn)
 {
-	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+	if (iomem_is_exclusive(PFN_PHYS(pfn)))
 		return 0;
 	if (!page_is_ram(pfn))
 		return 1;
-- 
2.32.0

