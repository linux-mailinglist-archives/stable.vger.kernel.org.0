Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E23FEFA5
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfKPPxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbfKPPxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:32 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DB3218A3;
        Sat, 16 Nov 2019 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919611;
        bh=SD1+ZK9OmCUCUovyv9SYJ8BesDSNpcNeA9aYJoHtpTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwJtf+A1puAUUoh4+J9RzbuPUGDK3eDg5Y8SdBwV2rJFdcBAlVNiCOddWHrSDpc+A
         v2DI9NMNUpnGmy8+TajxWsdZuqr6txCRxxBBZVOZplsAyfpc97Eb0J80iZSpRNXhAA
         D67V778dvkoOIaJIco5H0nXeVjTyaEw9DW02Mc0E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Yang yingliang <yangyingliang@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 98/99] mm/memory_hotplug: Do not unlock when fails to take the device_hotplug_lock
Date:   Sat, 16 Nov 2019 10:51:01 -0500
Message-Id: <20191116155103.10971-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit d2ab99403ee00d8014e651728a4702ea1ae5e52c ]

When adding the memory by probing memory block in sysfs interface, there is an
obvious issue that we will unlock the device_hotplug_lock when fails to takes it.

That issue was introduced in Commit 8df1d0e4a265
("mm/memory_hotplug: make add_memory() take the device_hotplug_lock")

We should drop out in time when fails to take the device_hotplug_lock.

Fixes: 8df1d0e4a265 ("mm/memory_hotplug: make add_memory() take the device_hotplug_lock")
Reported-by: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9f96f1b43c15f..6a3694a4843f8 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -502,7 +502,7 @@ memory_probe_store(struct device *dev, struct device_attribute *attr,
 
 	ret = lock_device_hotplug_sysfs();
 	if (ret)
-		goto out;
+		return ret;
 
 	nid = memory_add_physaddr_to_nid(phys_addr);
 	ret = __add_memory(nid, phys_addr,
-- 
2.20.1

