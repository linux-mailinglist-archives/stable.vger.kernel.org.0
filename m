Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85D5747A6
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfGYHBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfGYHBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:01:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0371B2070B;
        Thu, 25 Jul 2019 07:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564038064;
        bh=4CfUye+GgQ2gJMBez5GCw03r+W5Lg5lhKAG1QSnvLsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sz7jyTkEKYHv9cAcxBMbDFFyk9Vg7lLKUrhtVicOoAyf4BGFbsS/HFB2Myr8wSoMF
         5oqAHUWN2+iGkSUd5Lw79E78S5Ske2mbT72gE6QBSKdw0pR9diYO/7hsuH0cdYXarb
         RCpSgpzFhVg7o+BA2oee+4hDc8kzfv779bED68OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 024/413] media: vpss: fix a potential NULL pointer dereference
Date:   Wed, 24 Jul 2019 21:15:15 +0200
Message-Id: <20190724191737.185755747@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e08f0761234def47961d3252eac09ccedfe4c6a0 ]

In case ioremap fails, the fix returns -ENOMEM to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 3f079ac1b080..be91b0c7d20b 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -509,6 +509,11 @@ static int __init vpss_init(void)
 		return -EBUSY;
 
 	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+	if (unlikely(!oper_cfg.vpss_regs_base2)) {
+		release_mem_region(VPSS_CLK_CTRL, 4);
+		return -ENOMEM;
+	}
+
 	writel(VPSS_CLK_CTRL_VENCCLKEN |
 		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
 
-- 
2.20.1



