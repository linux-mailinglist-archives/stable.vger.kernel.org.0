Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA36A119464
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfLJVPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbfLJVNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636C521D7D;
        Tue, 10 Dec 2019 21:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012413;
        bh=NjRlAIeHy2SuCz+QP9LYcmS5+EbVEaQg+w2B50lwxqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0WFqYaUnogY7mp3wL20P6sgLzJZ+lfUEvfDkkYIfscf+OFoYqnOJHTnIzhRMj/F/
         Avxi6cur3P2cRDwbaH3u0lqzL4ee1XEgrPeji5VD+UX3wC0RhWka4KNpjOZbVBRyE7
         BvCs3kkZKGY1OnGI+Kzh1NlrxMJ7JXAvTgZz3luE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Richter <rrichter@marvell.com>,
        John Garry <john.garry@huawei.com>,
        Borislav Petkov <bp@suse.de>, huangming23@huawei.com,
        James Morse <james.morse@arm.com>, linuxarm@huawei.com,
        linux-edac <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        tanxiaofei@huawei.com, Tony Luck <tony.luck@intel.com>,
        wanghuiqiang@huawei.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 330/350] EDAC/ghes: Do not warn when incrementing refcount on 0
Date:   Tue, 10 Dec 2019 16:07:15 -0500
Message-Id: <20191210210735.9077-291-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

[ Upstream commit 16214bd9e43a31683a7073664b000029bba00354 ]

The following warning from the refcount framework is seen during ghes
initialization:

  EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
  ------------[ cut here ]------------
  refcount_t: increment on 0; use-after-free.
  WARNING: CPU: 36 PID: 1 at lib/refcount.c:156 refcount_inc_checked
 [...]
  Call trace:
   refcount_inc_checked
   ghes_edac_register
   ghes_probe
   ...

It warns if the refcount is incremented from zero. This warning is
reasonable as a kernel object is typically created with a refcount of
one and freed once the refcount is zero. Afterwards the object would be
"used-after-free".

For GHES, the refcount is initialized with zero, and that is why this
message is seen when initializing the first instance. However, whenever
the refcount is zero, the device will be allocated and registered. Since
the ghes_reg_mutex protects the refcount and serializes allocation and
freeing of ghes devices, a use-after-free cannot happen here.

Instead of using refcount_inc() for the first instance, use
refcount_set(). This can be used here because the refcount is zero at
this point and can not change due to its protection by the mutex.

Fixes: 23f61b9fc5cc ("EDAC/ghes: Fix locking and memory barrier issues")
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Cc: <huangming23@huawei.com>
Cc: James Morse <james.morse@arm.com>
Cc: <linuxarm@huawei.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <tanxiaofei@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <wanghuiqiang@huawei.com>
Link: https://lkml.kernel.org/r/20191121213628.21244-1-rrichter@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ghes_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 1858baa96211b..523dd56a798c9 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -572,8 +572,8 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	ghes_pvt = pvt;
 	spin_unlock_irqrestore(&ghes_lock, flags);
 
-	/* only increment on success */
-	refcount_inc(&ghes_refcount);
+	/* only set on success */
+	refcount_set(&ghes_refcount, 1);
 
 unlock:
 	mutex_unlock(&ghes_reg_mutex);
-- 
2.20.1

