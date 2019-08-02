Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F917F12E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbfHBJgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbfHBJgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC3E20679;
        Fri,  2 Aug 2019 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738606;
        bh=8IIMUHMrZoPzODrWWUAqnXm6e6fPk7EjY17juQs2q7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfKfTKXPkPXoJVHyUbnl4zGpuiRtVZUm229OgjMru21+gYCN5wjn0DjwhLnde0QIL
         +ADCSzmcV+oW5qaFPFfT/DcjYlgwB2km95OTyE5bXzML2bYGHGaPXL6eutQg6aGBRb
         8l+x+gp9I/fyecdhbhEfi/B0BEYwhhW8y0eD3X9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 012/158] media: vpss: fix a potential NULL pointer dereference
Date:   Fri,  2 Aug 2019 11:27:13 +0200
Message-Id: <20190802092205.941621441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
index fce86f17dffc..c2c68988e38a 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -523,6 +523,11 @@ static int __init vpss_init(void)
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



