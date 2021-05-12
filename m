Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA637C43F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhELP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234803AbhELPZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925AD6141C;
        Wed, 12 May 2021 15:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832237;
        bh=BJS27XRKhusUx8jqKkiJ8QKpqpYh14YxJNYeWwrTyy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6kmMbL4wQQnMqxfoyyopw/EaeNVzGdIRxtUFTXB9I8WQMZyPB4SOmWFL8Z9jXhby
         uc2T/pmowUqXg0gc2lsQDi+dAeEazbwbhVBvIkG/+RIZ/5Ux+cq3wOuTpO5Feazhl9
         9IdEwHBDdYxrVZSmJNy3kn4n7tdu9cHbB07Fpee4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ravi Kumar Bokka <rbokka@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/530] drivers: nvmem: Fix voltage settings for QTI qfprom-efuse
Date:   Wed, 12 May 2021 16:45:08 +0200
Message-Id: <20210512144826.343287571@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Kumar Bokka <rbokka@codeaurora.org>

[ Upstream commit 9ec4f4b0e9fd3ad4b9a38bddb75b516ea09f4628 ]

QFPROM controller hardware requires 1.8V min for fuse blowing.
So, this change sets the voltage to 1.8V, required to blow the fuse
for qfprom-efuse controller.

To disable fuse blowing, we set the voltage to 0V since this may
be a shared rail and may be able to run at a lower rate when we're
not blowing fuses.

Fixes: 93b4e49f8c86 ("nvmem: qfprom: Add fuse blowing support")
Reported-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ravi Kumar Bokka <rbokka@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210330111241.19401-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/qfprom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
index 5e9e60e2e591..955b8b8c8238 100644
--- a/drivers/nvmem/qfprom.c
+++ b/drivers/nvmem/qfprom.c
@@ -104,6 +104,16 @@ static void qfprom_disable_fuse_blowing(const struct qfprom_priv *priv,
 {
 	int ret;
 
+	/*
+	 * This may be a shared rail and may be able to run at a lower rate
+	 * when we're not blowing fuses.  At the moment, the regulator framework
+	 * applies voltage constraints even on disabled rails, so remove our
+	 * constraints and allow the rail to be adjusted by other users.
+	 */
+	ret = regulator_set_voltage(priv->vcc, 0, INT_MAX);
+	if (ret)
+		dev_warn(priv->dev, "Failed to set 0 voltage (ignoring)\n");
+
 	ret = regulator_disable(priv->vcc);
 	if (ret)
 		dev_warn(priv->dev, "Failed to disable regulator (ignoring)\n");
@@ -149,6 +159,17 @@ static int qfprom_enable_fuse_blowing(const struct qfprom_priv *priv,
 		goto err_clk_prepared;
 	}
 
+	/*
+	 * Hardware requires 1.8V min for fuse blowing; this may be
+	 * a rail shared do don't specify a max--regulator constraints
+	 * will handle.
+	 */
+	ret = regulator_set_voltage(priv->vcc, 1800000, INT_MAX);
+	if (ret) {
+		dev_err(priv->dev, "Failed to set 1.8 voltage\n");
+		goto err_clk_rate_set;
+	}
+
 	ret = regulator_enable(priv->vcc);
 	if (ret) {
 		dev_err(priv->dev, "Failed to enable regulator\n");
-- 
2.30.2



