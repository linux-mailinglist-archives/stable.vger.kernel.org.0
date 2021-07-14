Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6C3C8E0B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbhGNTqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234682AbhGNTpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E052E613ED;
        Wed, 14 Jul 2021 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291730;
        bh=6+Wlq+NCWafYBSgguk87hl6FjEhjLQXdS/RTcB7OM0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEdaPhG53U6TiX/UgUiho1GdHUWijDEU68J1f1Gs6CqZEl+4L2kmQWVoGEj4jd1GG
         /k8L//u0B8JtUob0ZSHbuvsxSWgWXbkPIM5S8oXTyIklwTpeIQ6AD/9rL+jGLQEq1+
         leJOq0U6NikoPH6Fd3nJ4cAt7RJplwrgr62Px7NoyonNSIBd3Ef8gwLTeZCSs0yMJH
         1nWNUDDOnEdOFARUeZ88PcVF4zsU9+4rpiwBEWZab2dpjy8gUcRmuuM1yI6GxeZ40Y
         F9WrqQfQKVQ85n3NqmDc4Ixl4LW1VAOYi3XTNMMY3SxwJhahMIb0KEkMX15nYjpkqr
         B7nrZE9P+TTkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 066/102] i3c: master: svc: drop free_irq of devm_request_irq allocated irq
Date:   Wed, 14 Jul 2021 15:39:59 -0400
Message-Id: <20210714194036.53141-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 8d990696676e..014936120f4a 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1449,7 +1449,6 @@ static int svc_i3c_master_remove(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	free_irq(master->irq, master);
 	clk_disable_unprepare(master->pclk);
 	clk_disable_unprepare(master->fclk);
 	clk_disable_unprepare(master->sclk);
-- 
2.30.2

