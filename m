Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCC414564E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgAVNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730771AbgAVNZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:10 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217CA2467B;
        Wed, 22 Jan 2020 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699509;
        bh=rXFJZWdzOEkV5l16XswJpgwbtlDI+Ti+0UfzDeHAtfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5w3DukuKQxDqxCi1rqn5tjID+uW7MwJX0LKTwamcwoHdFTQVuT8XoB3Jy0JRvNAI
         edIC1khUji1j4lz0JTur5Eq2XeY1OiJSyFZh+oDlUhplGoxcZh1YA9qtAA4Z4+knrD
         0osOS9/8y1JE+EXqyXeUppcZPhdWRnMMpep5xHXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 167/222] net: stmmac: selftests: Update status when disabling RSS
Date:   Wed, 22 Jan 2020 10:29:13 +0100
Message-Id: <20200122092845.668971634@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit e715d74504352968cf24ac95476706bc911a69cd upstream.

We are disabling RSS on HW but not updating the internal private status
to the 'disabled' state. This is needed for next tc commit that will
check if RSS is disabled before trying to apply filters.

Fixes: 4647e021193d ("net: stmmac: selftests: Add selftest for L3/L4 Filters")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c |   20 +++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1297,16 +1297,19 @@ static int __stmmac_test_l3filt(struct s
 	struct stmmac_packet_attrs attr = { };
 	struct flow_dissector *dissector;
 	struct flow_cls_offload *cls;
+	int ret, old_enable = 0;
 	struct flow_rule *rule;
-	int ret;
 
 	if (!tc_can_offload(priv->dev))
 		return -EOPNOTSUPP;
 	if (!priv->dma_cap.l3l4fnum)
 		return -EOPNOTSUPP;
-	if (priv->rss.enable)
+	if (priv->rss.enable) {
+		old_enable = priv->rss.enable;
+		priv->rss.enable = false;
 		stmmac_rss_configure(priv, priv->hw, NULL,
 				     priv->plat->rx_queues_to_use);
+	}
 
 	dissector = kzalloc(sizeof(*dissector), GFP_KERNEL);
 	if (!dissector) {
@@ -1373,7 +1376,8 @@ cleanup_cls:
 cleanup_dissector:
 	kfree(dissector);
 cleanup_rss:
-	if (priv->rss.enable) {
+	if (old_enable) {
+		priv->rss.enable = old_enable;
 		stmmac_rss_configure(priv, priv->hw, &priv->rss,
 				     priv->plat->rx_queues_to_use);
 	}
@@ -1418,16 +1422,19 @@ static int __stmmac_test_l4filt(struct s
 	struct stmmac_packet_attrs attr = { };
 	struct flow_dissector *dissector;
 	struct flow_cls_offload *cls;
+	int ret, old_enable = 0;
 	struct flow_rule *rule;
-	int ret;
 
 	if (!tc_can_offload(priv->dev))
 		return -EOPNOTSUPP;
 	if (!priv->dma_cap.l3l4fnum)
 		return -EOPNOTSUPP;
-	if (priv->rss.enable)
+	if (priv->rss.enable) {
+		old_enable = priv->rss.enable;
+		priv->rss.enable = false;
 		stmmac_rss_configure(priv, priv->hw, NULL,
 				     priv->plat->rx_queues_to_use);
+	}
 
 	dissector = kzalloc(sizeof(*dissector), GFP_KERNEL);
 	if (!dissector) {
@@ -1499,7 +1506,8 @@ cleanup_cls:
 cleanup_dissector:
 	kfree(dissector);
 cleanup_rss:
-	if (priv->rss.enable) {
+	if (old_enable) {
+		priv->rss.enable = old_enable;
 		stmmac_rss_configure(priv, priv->hw, &priv->rss,
 				     priv->plat->rx_queues_to_use);
 	}


