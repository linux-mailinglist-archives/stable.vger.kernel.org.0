Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C18499A7D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390588AbfHVRI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390576AbfHVRI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:56 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8283E2341B;
        Thu, 22 Aug 2019 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493735;
        bh=XPa39C+ImOWiH3ShEPLYIBOk+rk+TWk7X2QkYKWN7SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaDR15K4z4Hrzqu0Yd6ISM9yK3Kr/KJXJCbwXXGKIfVmbVG0A9kenY2lJ1lqVW8DC
         rpj+U2S9Wvh4Cm377FvmFGz3h+uIkcI++d0pr3j0Aa8qIcBwRhlSjMT859IxPTpUHq
         7Cjr+vuhq68egkAzJF5DRxsQ37RpJwVRGRtE7JAQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 076/135] IB/core: Add mitigation for Spectre V1
Date:   Thu, 22 Aug 2019 13:07:12 -0400
Message-Id: <20190822170811.13303-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>

[ Upstream commit 61f259821dd3306e49b7d42a3f90fb5a4ff3351b ]

Some processors may mispredict an array bounds check and
speculatively access memory that they should not. With
a user supplied array index we like to play things safe
by masking the value with the array size before it is
used as an index.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20190731043957.GA1600@agluck-desk2.amr.corp.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/user_mad.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 671f07ba1fad6..025b6d86a61fc 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/semaphore.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 
@@ -883,11 +884,14 @@ static int ib_umad_unreg_agent(struct ib_umad_file *file, u32 __user *arg)
 
 	if (get_user(id, arg))
 		return -EFAULT;
+	if (id >= IB_UMAD_MAX_AGENTS)
+		return -EINVAL;
 
 	mutex_lock(&file->port->file_mutex);
 	mutex_lock(&file->mutex);
 
-	if (id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
+	id = array_index_nospec(id, IB_UMAD_MAX_AGENTS);
+	if (!__get_agent(file, id)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.20.1

