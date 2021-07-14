Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5903C8D7A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhGNTou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235026AbhGNTmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C196C600D4;
        Wed, 14 Jul 2021 19:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291581;
        bh=Z4P5MoOI1A3rTntoZ5jca6mUwSxAZ6VYmqDO5ThiPEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocQp8UBRXyl2gqOujrqSHruJdIEQfC9tMdsLOnzAQYfEPo1HHm+ATAkVvPPmLzHr6
         vIhQChm+ZXetnJES2hLJQ57qWx4EL6L+YtVuV8SDoQavJNHTR7sRdmmKKgp/3QNfqD
         snHoiOJdZhCNTi+tg4d/vZQPemczGysAkH0FnDFwpbj0bBhV+bj3vzfMH1C9KmuUM3
         bEFg4VI5+QnBXblW84ySkPtfcunrMYa42kaL96+qZIjQbec84fJpZghXg28R/XJtCn
         QAly/qskA/XKAWD63sCYpmN/mTLMrTsP0YpG9YriIRzSSAE3+zo8FZ1aEMZsrET1wk
         SnubSPsX/SgLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 069/108] i3c: master: svc: drop free_irq of devm_request_irq allocated irq
Date:   Wed, 14 Jul 2021 15:37:21 -0400
Message-Id: <20210714193800.52097-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 59a61e69c4252b4e8ecd15e752b0d2337f0121b7 ]

irq allocated with devm_request_irq() will be freed in devm_irq_release(),
using free_irq() in ->remove() will causes a dangling pointer, and a
subsequent double free. So remove the free_irq() in svc_i3c_master_remove().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210602084935.3977636-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 1f6ba4221817..eeb49b5d90ef 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1448,7 +1448,6 @@ static int svc_i3c_master_remove(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	free_irq(master->irq, master);
 	clk_disable_unprepare(master->pclk);
 	clk_disable_unprepare(master->fclk);
 	clk_disable_unprepare(master->sclk);
-- 
2.30.2

