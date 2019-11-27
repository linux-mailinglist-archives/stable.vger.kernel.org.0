Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6210BDF2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbfK0Uwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbfK0Uwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB67521847;
        Wed, 27 Nov 2019 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887960;
        bh=2M4bqX0FVUlvTYzZ0S0NnLRYZpiCJU8Fr7rhThqDBW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhmtre/RA4U4N/BDKV4eYki43NtqhfXhmwYZkPA9WHLsgdZHRldnM3LA7CcT4LTac
         Qh74lNn7GTrxqkuI978ymaPBiwu2ENlwgtOF+cXOEcQtclqIf29HEBdvIh/hVj7y5A
         +DJqKrtBtzwya7LwTu+lp+LBFSjLyCnXpQly9nBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang yingliang <yangyingliang@huawei.com>,
        zhong jiang <zhongjiang@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 161/211] mm/memory_hotplug: Do not unlock when fails to take the device_hotplug_lock
Date:   Wed, 27 Nov 2019 21:31:34 +0100
Message-Id: <20191127203109.133669683@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8e5818e735e2f..fe1557aa9b103 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -519,7 +519,7 @@ memory_probe_store(struct device *dev, struct device_attribute *attr,
 
 	ret = lock_device_hotplug_sysfs();
 	if (ret)
-		goto out;
+		return ret;
 
 	nid = memory_add_physaddr_to_nid(phys_addr);
 	ret = __add_memory(nid, phys_addr,
-- 
2.20.1



