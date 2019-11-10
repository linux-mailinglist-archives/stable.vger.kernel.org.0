Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8998F6282
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfKJCnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbfKJCnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB498222BE;
        Sun, 10 Nov 2019 02:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353814;
        bh=Rfmjqkau+tjt9cLR5sKx6mt50z1XkyNZEX7X5G4NvvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1O14442mWzzUIZHwaXrZNKZJT8jhf87nXscHoHRuB0d5O/78UZ1sjktfkcMvmkm4L
         I42kF2jJlxje9Vpd9xi+fIFDkQR1COmJIGApovEAwQNR6kSxzeVtsntKRYfB73ScNz
         dBz2+3YkGEel+HpyLY1sL7xj/Qpym6JA2oh8xQOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 110/191] coresight: Use ERR_CAST instead of ERR_PTR
Date:   Sat,  9 Nov 2019 21:38:52 -0500
Message-Id: <20191110024013.29782-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

