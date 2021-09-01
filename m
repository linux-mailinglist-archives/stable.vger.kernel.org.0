Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585E43FDB69
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbhIAMlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344642AbhIAMju (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D6A1610A1;
        Wed,  1 Sep 2021 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499738;
        bh=dKA32apQBghroQQaMnexSRfBljkENbuWIrpf1wYT4u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1x8Q1zE3v6LSWasVkz1H86X8yazLifv7f9MfeGwclszTNL6At3hHsvcQBROZoX3N7
         8oTGbSbYxgjKZ6Vdqvh02ms6FoW8FTHU+UkiSZKlJj/qIp4HQkGJLYVlhfGtvpkksK
         LZ8eqIwHmCC1HbQRe+jsO9gx3nI3YKq+roWRcO94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/103] RDMA/bnxt_re: Add missing spin lock initialization
Date:   Wed,  1 Sep 2021 14:27:33 +0200
Message-Id: <20210901122301.304153557@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>

[ Upstream commit 17f2569dce1848080825b8336e6b7c6900193b44 ]

Add the missing initialization of srq lock.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Link: https://lore.kernel.org/r/1629343553-5843-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 266de55f5719..441952a5eca4 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1691,6 +1691,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	if (nq)
 		nq->budget++;
 	atomic_inc(&rdev->srq_count);
+	spin_lock_init(&srq->lock);
 
 	return 0;
 
-- 
2.30.2



