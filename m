Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFAD2170FF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgGGPXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729950AbgGGPXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE16B207CD;
        Tue,  7 Jul 2020 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135389;
        bh=t48+Xhwq9/p8QGgsPqjcI4Z6WeMmsCy0ku+QepkjvXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ww75triTQgAHN1JQZlS7oCve4Mw5O51C7dvlpVr34Cy2g1e0gJN2sao9ZSksI8DoD
         2VbSIjz/RSjrPBHVwDk2p5bLpScrUl7ps/AYlbXEuRRbPu196ssG35gfWU6wIpRNIo
         X3LeD7/obuIAIA7Z0UKORme9v4x7h5YUAw9ElNFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 021/112] soc: ti: omap-prm: use atomic iopoll instead of sleeping one
Date:   Tue,  7 Jul 2020 17:16:26 +0200
Message-Id: <20200707145801.997136149@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 98ece19f247159a51003796ede7112fef2df5d7f ]

The reset handling APIs for omap-prm can be invoked PM runtime which
runs in atomic context. For this to work properly, switch to atomic
iopoll version instead of the current which can sleep. Otherwise,
this throws a "BUG: scheduling while atomic" warning. Issue is seen
rather easily when CONFIG_PREEMPT is enabled.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 96c6f777519c0..c9b3f9ebf0bbf 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -256,10 +256,10 @@ static int omap_reset_deassert(struct reset_controller_dev *rcdev,
 		goto exit;
 
 	/* wait for the status to be set */
-	ret = readl_relaxed_poll_timeout(reset->prm->base +
-					 reset->prm->data->rstst,
-					 v, v & BIT(st_bit), 1,
-					 OMAP_RESET_MAX_WAIT);
+	ret = readl_relaxed_poll_timeout_atomic(reset->prm->base +
+						 reset->prm->data->rstst,
+						 v, v & BIT(st_bit), 1,
+						 OMAP_RESET_MAX_WAIT);
 	if (ret)
 		pr_err("%s: timedout waiting for %s:%lu\n", __func__,
 		       reset->prm->data->name, id);
-- 
2.25.1



