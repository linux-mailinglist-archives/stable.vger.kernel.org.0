Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA40401BD8
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243395AbhIFM75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243398AbhIFM7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A83461039;
        Mon,  6 Sep 2021 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933092;
        bh=h4s6S/fKS1X94ZYE2zRjyE0IgdC/3AncBjqqAi/i0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DjgpVfNOSG+YD2akNfQqQJzfcEBWpzCquoT2S0+4ig2TODv+byEXB9CEIjWuQCL2
         qrrFle8CGH1I0cr1GKSxhX7JUMZacdz3TU7BVYvLBq4o54OI6iALjXH2kcUmlqVMsN
         +73er+9rufHCm7DbuAcCqGbVJ/wSfDfGIjGrvflA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 04/24] reset: reset-zynqmp: Fixed the argument data type
Date:   Mon,  6 Sep 2021 14:55:33 +0200
Message-Id: <20210906125449.257885453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>

[ Upstream commit ed104ca4bd9c405b41e968ad4ece51f6462e90b6 ]

This patch changes the data type of the variable 'val' from
int to u32.

Addresses-Coverity: argument of type "int *" is incompatible with parameter of type "u32 *"
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/925cebbe4eb73c7d0a536da204748d33c7100d8c.1624448778.git.michal.simek@xilinx.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-zynqmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-zynqmp.c b/drivers/reset/reset-zynqmp.c
index ebd433fa09dd..8c51768e9a72 100644
--- a/drivers/reset/reset-zynqmp.c
+++ b/drivers/reset/reset-zynqmp.c
@@ -53,7 +53,8 @@ static int zynqmp_reset_status(struct reset_controller_dev *rcdev,
 			       unsigned long id)
 {
 	struct zynqmp_reset_data *priv = to_zynqmp_reset_data(rcdev);
-	int val, err;
+	int err;
+	u32 val;
 
 	err = zynqmp_pm_reset_get_status(priv->data->reset_id + id, &val);
 	if (err)
-- 
2.30.2



