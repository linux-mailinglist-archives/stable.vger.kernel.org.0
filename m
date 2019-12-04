Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479D41131CA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbfLDSCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfLDSCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:34 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DCF20863;
        Wed,  4 Dec 2019 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482553;
        bh=z8Iyzpjt8JKb+vgUozi+1J3dLfGgj3QCzA7NIlEf3K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URvUXjQyuUrNp9SWWx3YuIR8Hwcc9UB1IKR5KvpPGTtHrtn8Dt3C6pUdxzNdjwHjN
         FFbrLQqeCQQ7hXBzrw9R5gi+tlHHn6oVFnxG5DoguVF/K2k+GaiUoi4xD8Wh/UsJdc
         p73D6ILqHfttbr1Hz1kttSjkLmz8q5Palm5+7Zgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adit Ranadive <aditr@vmware.com>,
        Gal Pressman <galpress@amazon.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/209] RDMA/vmw_pvrdma: Use atomic memory allocation in create AH
Date:   Wed,  4 Dec 2019 18:54:12 +0100
Message-Id: <20191204175324.182743688@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit a276a4d93bf1580d737f38d1810e5f4b166f3edd ]

Create address handle callback should not sleep, use GFP_ATOMIC instead of
GFP_KERNEL for memory allocation.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Cc: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index aa533f08e0171..5c7aa6ff15382 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -550,7 +550,7 @@ struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 	if (!atomic_add_unless(&dev->num_ahs, 1, dev->dsr->caps.max_ah))
 		return ERR_PTR(-ENOMEM);
 
-	ah = kzalloc(sizeof(*ah), GFP_KERNEL);
+	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah) {
 		atomic_dec(&dev->num_ahs);
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1



