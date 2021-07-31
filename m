Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461D23DC2C6
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 04:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhGaCvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 22:51:13 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13217 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhGaCvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 22:51:12 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Gc7sY6FTdz1CQtM;
        Sat, 31 Jul 2021 10:45:05 +0800 (CST)
Received: from huawei.com (100.120.247.70) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 31
 Jul 2021 10:51:04 +0800
From:   Liang Wang <wangliang101@huawei.com>
To:     <palmerdabbelt@google.com>, <mcgrof@kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC:     <stable@vger.kernel.org>, <wangliang101@huawei.com>,
        <wangle6@huawei.com>, <kepler.chenxin@huawei.com>,
        <nixiaoming@huawei.com>, <wangkefeng.wang@huawei.com>
Subject: [PATCH v3] lib: Use PFN_PHYS() in devmem_is_allowed()
Date:   Sat, 31 Jul 2021 10:50:57 +0800
Message-ID: <20210731025057.78825-1-wangliang101@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [100.120.247.70]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The physical address may exceed 32 bits on 32-bit systems with
more than 32 bits of physcial address,use PFN_PHYS() in devmem_is_allowed(),
or the physical address may overflow and be truncated.
We found this bug when mapping a high addresses through devmem tool,
when CONFIG_STRICT_DEVMEM is enabled on the ARM with ARM_LPAE and devmem
is used to map a high address that is not in the iomem address range,
an unexpected error indicating no permission is returned.

This bug was initially introduced from v2.6.37, and the function was moved
to lib when v5.11.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
Cc: stable@vger.kernel.org # v2.6.37
Signed-off-by: Liang Wang <wangliang101@huawei.com>
---
v3: update changelog suggested by Luis Chamberlain <mcgrof@kernel.org>
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

