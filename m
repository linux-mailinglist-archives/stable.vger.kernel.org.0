Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B5329B26E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762167AbgJ0OlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762005AbgJ0Ok3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:40:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3271206B2;
        Tue, 27 Oct 2020 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809628;
        bh=NS9e1vNo5Vgao+ywJ79TgVFEtYV3FeufPRb98X6SoaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSH3colKW9labzP0HKPQjU04zewV87Du3bGZ2kuxWAz0t7JLkSl1hE8VKsECxuq80
         kx4Yfs3r3JvFn8nC97vKE99iKEEklUyuSOpn7KBYXYGykFjJXV9CwgBzGLgeA37anX
         3YYRcXMv4smvBDEsF7FHWOhjuXxUWhpVfJmcex/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/408] rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()
Date:   Tue, 27 Oct 2020 14:53:22 +0100
Message-Id: <20201027135507.291640547@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e69ee0cf655e8e0c4a80f4319e36019b74f17639 ]

We need to call of_node_put(node) on the error paths for this function.

Fixes: 53e2822e56c7 ("rpmsg: Introduce Qualcomm SMD backend")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200908071841.GA294938@mwanda
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 4abbeea782fa4..19903de6268db 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1338,7 +1338,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 	ret = of_property_read_u32(node, key, &edge->edge_id);
 	if (ret) {
 		dev_err(dev, "edge missing %s property\n", key);
-		return -EINVAL;
+		goto put_node;
 	}
 
 	edge->remote_pid = QCOM_SMEM_HOST_ANY;
@@ -1349,32 +1349,37 @@ static int qcom_smd_parse_edge(struct device *dev,
 	edge->mbox_client.knows_txdone = true;
 	edge->mbox_chan = mbox_request_channel(&edge->mbox_client, 0);
 	if (IS_ERR(edge->mbox_chan)) {
-		if (PTR_ERR(edge->mbox_chan) != -ENODEV)
-			return PTR_ERR(edge->mbox_chan);
+		if (PTR_ERR(edge->mbox_chan) != -ENODEV) {
+			ret = PTR_ERR(edge->mbox_chan);
+			goto put_node;
+		}
 
 		edge->mbox_chan = NULL;
 
 		syscon_np = of_parse_phandle(node, "qcom,ipc", 0);
 		if (!syscon_np) {
 			dev_err(dev, "no qcom,ipc node\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto put_node;
 		}
 
 		edge->ipc_regmap = syscon_node_to_regmap(syscon_np);
-		if (IS_ERR(edge->ipc_regmap))
-			return PTR_ERR(edge->ipc_regmap);
+		if (IS_ERR(edge->ipc_regmap)) {
+			ret = PTR_ERR(edge->ipc_regmap);
+			goto put_node;
+		}
 
 		key = "qcom,ipc";
 		ret = of_property_read_u32_index(node, key, 1, &edge->ipc_offset);
 		if (ret < 0) {
 			dev_err(dev, "no offset in %s\n", key);
-			return -EINVAL;
+			goto put_node;
 		}
 
 		ret = of_property_read_u32_index(node, key, 2, &edge->ipc_bit);
 		if (ret < 0) {
 			dev_err(dev, "no bit in %s\n", key);
-			return -EINVAL;
+			goto put_node;
 		}
 	}
 
@@ -1385,7 +1390,8 @@ static int qcom_smd_parse_edge(struct device *dev,
 	irq = irq_of_parse_and_map(node, 0);
 	if (irq < 0) {
 		dev_err(dev, "required smd interrupt missing\n");
-		return -EINVAL;
+		ret = irq;
+		goto put_node;
 	}
 
 	ret = devm_request_irq(dev, irq,
@@ -1393,12 +1399,18 @@ static int qcom_smd_parse_edge(struct device *dev,
 			       node->name, edge);
 	if (ret) {
 		dev_err(dev, "failed to request smd irq\n");
-		return ret;
+		goto put_node;
 	}
 
 	edge->irq = irq;
 
 	return 0;
+
+put_node:
+	of_node_put(node);
+	edge->of_node = NULL;
+
+	return ret;
 }
 
 /*
-- 
2.25.1



