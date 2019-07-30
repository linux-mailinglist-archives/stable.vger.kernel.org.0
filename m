Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1332C7A9A8
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfG3NcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 09:32:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731037AbfG3NcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 09:32:08 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5C8C33A1EFFBA114B0C5;
        Tue, 30 Jul 2019 21:32:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 30 Jul 2019 21:31:54 +0800
From:   John Garry <john.garry@huawei.com>
To:     <xuwei5@huawei.com>
CC:     <bhelgaas@google.com>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <olof@lixom.net>,
        <stable@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH v4 3/5] lib: logic_pio: Add logic_pio_unregister_range()
Date:   Tue, 30 Jul 2019 21:29:54 +0800
Message-ID: <1564493396-92195-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1564493396-92195-1-git-send-email-john.garry@huawei.com>
References: <1564493396-92195-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a function to unregister a logical PIO range.

Logical PIO space can still be leaked when unregistering certain
LOGIC_PIO_CPU_MMIO regions, but this acceptable for now since there are no
callers to unregister LOGIC_PIO_CPU_MMIO regions, and the logical PIO
region allocation scheme would need significant work to improve this.

Cc: stable@vger.kernel.org
Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/linux/logic_pio.h |  1 +
 lib/logic_pio.c           | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/logic_pio.h b/include/linux/logic_pio.h
index cbd9d8495690..88e1e6304a71 100644
--- a/include/linux/logic_pio.h
+++ b/include/linux/logic_pio.h
@@ -117,6 +117,7 @@ struct logic_pio_hwaddr *find_io_range_by_fwnode(struct fwnode_handle *fwnode);
 unsigned long logic_pio_trans_hwaddr(struct fwnode_handle *fwnode,
 			resource_size_t hw_addr, resource_size_t size);
 int logic_pio_register_range(struct logic_pio_hwaddr *newrange);
+void logic_pio_unregister_range(struct logic_pio_hwaddr *range);
 resource_size_t logic_pio_to_hwaddr(unsigned long pio);
 unsigned long logic_pio_trans_cpuaddr(resource_size_t hw_addr);
 
diff --git a/lib/logic_pio.c b/lib/logic_pio.c
index d0165c88f705..905027574e5d 100644
--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -98,6 +98,20 @@ int logic_pio_register_range(struct logic_pio_hwaddr *new_range)
 	return ret;
 }
 
+/**
+ * logic_pio_unregister_range - unregister a logical PIO range for a host
+ * @range: pointer to the IO range which has been already registered.
+ *
+ * Unregister a previously-registered IO range node.
+ */
+void logic_pio_unregister_range(struct logic_pio_hwaddr *range)
+{
+	mutex_lock(&io_range_mutex);
+	list_del_rcu(&range->list);
+	mutex_unlock(&io_range_mutex);
+	synchronize_rcu();
+}
+
 /**
  * find_io_range_by_fwnode - find logical PIO range for given FW node
  * @fwnode: FW node handle associated with logical PIO range
-- 
2.17.1

