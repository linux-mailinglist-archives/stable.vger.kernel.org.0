Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C8C37C9FF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhELQX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240130AbhELQRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54A1B61480;
        Wed, 12 May 2021 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834204;
        bh=Mgfy+Fc6FsToJDhZcqaHwXxWhy/3U+/Rm9Q4F0nNTU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTEmmcNEqRAhjAeRzal3ZHYg9xp7vfibHvTAMg0dMGY+zJ7bcmChNRubbdy18wT+V
         ehdPEaV7tpPFzSVQ7wvHRMkS5RbdHF0QI77ohRQ49R/qptPp9QBB5MvoDZBmxmIoEc
         275z94H/BCJ/PAguzT5V8mx87U2TFU/IC282O530=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Goldman <adam.goldman@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 451/601] IB/hfi1: Use kzalloc() for mmu_rb_handler allocation
Date:   Wed, 12 May 2021 16:48:48 +0200
Message-Id: <20210512144842.699085485@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

[ Upstream commit ca5f72568e034e1295a7ae350b1f786fcbfb2848 ]

The code currently assumes that the mmu_notifier struct
embedded in mmu_rb_handler only contains two fields.

There are now extra fields:

struct mmu_notifier {
        struct hlist_node hlist;
        const struct mmu_notifier_ops *ops;
        struct mm_struct *mm;
        struct rcu_head rcu;
        unsigned int users;
};

Given that there in no init for the mmu_notifier, a kzalloc() should
be used to insure that any newly added fields are given a predictable
initial value of zero.

Fixes: 06e0ffa69312 ("IB/hfi1: Re-factor MMU notification code")
Link: https://lore.kernel.org/r/1617026056-50483-9-git-send-email-dennis.dalessandro@cornelisnetworks.com
Reviewed-by: Adam Goldman <adam.goldman@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index f3fb28e3d5d7..d213f65d4cdd 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -89,7 +89,7 @@ int hfi1_mmu_rb_register(void *ops_arg,
 	struct mmu_rb_handler *h;
 	int ret;
 
-	h = kmalloc(sizeof(*h), GFP_KERNEL);
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
 
-- 
2.30.2



