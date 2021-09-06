Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F97401B7E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbhIFM51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242356AbhIFM50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B86CE61039;
        Mon,  6 Sep 2021 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630932981;
        bh=h4s6S/fKS1X94ZYE2zRjyE0IgdC/3AncBjqqAi/i0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02Lp6cGoW0REpinP4iXurGWMeCbNZll/ncwTE+2bNmo9/acWSmu5o8ULgvM/V/Wot
         RodX/y3MdcPqiPDVifppJFicNWZ+UY3fQnThwR4ZxPAoqfmKoIBn582cM7kysbNpFW
         RsXuQZn73BJiMqFQP6vc9k0jXjDBHT5Vxi0u7GX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/29] reset: reset-zynqmp: Fixed the argument data type
Date:   Mon,  6 Sep 2021 14:55:28 +0200
Message-Id: <20210906125450.232161917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
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



