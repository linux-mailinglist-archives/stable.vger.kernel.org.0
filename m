Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADB51017CA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbfKSFji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbfKSFji (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEB521823;
        Tue, 19 Nov 2019 05:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141977;
        bh=Rfmjqkau+tjt9cLR5sKx6mt50z1XkyNZEX7X5G4NvvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/x+0mW43pb4lG4OXokW59IeLZZZk6hUzoEMXxWP1XSWC0tKmzqmBqcXdCb4p583z
         iE0YvbA8+CH9MfReSIMV3UP8VxJ2PHqNwXkKjKPnDLHzQUPIz1W8R03N0sWBF9CjeG
         W+0w7tA+2FNi/AbhAOWUDqXQ/utqiaDXOiSqCEOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 344/422] coresight: Use ERR_CAST instead of ERR_PTR
Date:   Tue, 19 Nov 2019 06:19:01 +0100
Message-Id: <20191119051421.305408356@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit bbd35ba6fab5419e58e96f35f1431f13bdc14f98 ]

Use ERR_CAT inlined function to replace the ERR_PTR(PTR_ERR). It
make the code more concise.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 2eda5de304c20..11963647e19ae 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -536,7 +536,7 @@ tmc_init_etr_sg_table(struct device *dev, int node,
 	sg_table = tmc_alloc_sg_table(dev, node, nr_tpages, nr_dpages, pages);
 	if (IS_ERR(sg_table)) {
 		kfree(etr_table);
-		return ERR_PTR(PTR_ERR(sg_table));
+		return ERR_CAST(sg_table);
 	}
 
 	etr_table->sg_table = sg_table;
-- 
2.20.1



