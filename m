Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BD541CEB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376316AbiFGWHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383005AbiFGWEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE14A28E09;
        Tue,  7 Jun 2022 12:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0E461846;
        Tue,  7 Jun 2022 19:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C43C385A2;
        Tue,  7 Jun 2022 19:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629361;
        bh=9sepHHtUi18mB/sNM9vPJeMOF6rk7ZfA+svdQRMycS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTu+0ou5KpNd90Ze451I/ugSwunjoZD78rxH0tS3Ef8hRY8+yCXmQhN7HvWkPUrCi
         XW1Oa2St+hyPmdJkn/RUZGblyF0XQUnFjG2OrQPE7hLuZtGWmVF6e7Il6AUZXNolzU
         ZGI05TpwGXGdWcpuHJRqfZ3OQ4kIZkaO7aGgj8zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 663/879] iommu/amd: Do not call sleep while holding spinlock
Date:   Tue,  7 Jun 2022 19:03:01 +0200
Message-Id: <20220607165022.091002816@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 5edde870d3283edeaa27ab62ac4fac5ee8cae35a ]

Smatch static checker warns:
	drivers/iommu/amd/iommu_v2.c:133 free_device_state()
	warn: sleeping in atomic context

Fixes by storing the list of struct device_state in a temporary
list, and then free the memory after releasing the spinlock.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 9f968fc70d85 ("iommu/amd: Improve amd_iommu_v2_exit()")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20220314024321.37411-1-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu_v2.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index e56b137ceabd..afb3efd565b7 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -956,6 +956,7 @@ static void __exit amd_iommu_v2_exit(void)
 {
 	struct device_state *dev_state, *next;
 	unsigned long flags;
+	LIST_HEAD(freelist);
 
 	if (!amd_iommu_v2_supported())
 		return;
@@ -975,11 +976,20 @@ static void __exit amd_iommu_v2_exit(void)
 
 		put_device_state(dev_state);
 		list_del(&dev_state->list);
-		free_device_state(dev_state);
+		list_add_tail(&dev_state->list, &freelist);
 	}
 
 	spin_unlock_irqrestore(&state_lock, flags);
 
+	/*
+	 * Since free_device_state waits on the count to be zero,
+	 * we need to free dev_state outside the spinlock.
+	 */
+	list_for_each_entry_safe(dev_state, next, &freelist, list) {
+		list_del(&dev_state->list);
+		free_device_state(dev_state);
+	}
+
 	destroy_workqueue(iommu_wq);
 }
 
-- 
2.35.1



