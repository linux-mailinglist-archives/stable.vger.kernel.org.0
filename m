Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F4E2117A3
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgGBBWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgGBBWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:22:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA2820748;
        Thu,  2 Jul 2020 01:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652924;
        bh=t48+Xhwq9/p8QGgsPqjcI4Z6WeMmsCy0ku+QepkjvXw=;
        h=From:To:Cc:Subject:Date:From;
        b=qAd8IP2f4neblwS824klCsrbfs/Dt0tGiYA40MPNSzrrD1YEtog/X9DE/fAYCJqWi
         P7A5ZI19v82gLz512OkZlOaODixU1crtq1E07KF2fS3rEBbMvwCe/ac0+g1bJcYwG2
         AXhmk0U7jDAVjyCS3eEhsVcDUS9ZKnCjFyjIr1xQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 01/53] soc: ti: omap-prm: use atomic iopoll instead of sleeping one
Date:   Wed,  1 Jul 2020 21:21:10 -0400
Message-Id: <20200702012202.2700645-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

