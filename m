Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAD373801
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfGXTZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbfGXTZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D0C218EA;
        Wed, 24 Jul 2019 19:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996305;
        bh=vkubnwGwqggu4gM/JSBjnWe2XoZHpeGUfBMr8usYZYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMA5qvigGfmQXY2lPXg44Yy25mn/bWtRPNAPD1ALMt65PCDoGubW7bjBdNwvyk5n9
         GskZE1IK6DLpI+edncshMz99AyFYRxyFC4M76DqVT+tVKeJidnnH+xF1RawRFCDvTA
         XjWqhpGCmmdDp64/AMEtZWf+OyBRo5LN3/PUe4M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 033/413] net: mvpp2: cls: Extract the RSS context when parsing the ethtool rule
Date:   Wed, 24 Jul 2019 21:15:24 +0200
Message-Id: <20190724191737.956580831@linuxfoundation.org>
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

[ Upstream commit c561da68038a738f30eca21456534c2d1872d13d ]

ethtool_rx_flow_rule_create takes into parameter the ethtool flow spec,
which doesn't contain the rss context id. We therefore need to extract
it ourself before parsing the ethtool rule.

The FLOW_RSS flag is only set in info->fs.flow_type, and not
info->flow_type.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index a57d17ab91f0..fb06c0aa620a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1242,6 +1242,12 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 
 	input.fs = &info->fs;
 
+	/* We need to manually set the rss_ctx, since this info isn't present
+	 * in info->fs
+	 */
+	if (info->fs.flow_type & FLOW_RSS)
+		input.rss_ctx = info->rss_context;
+
 	ethtool_rule = ethtool_rx_flow_rule_create(&input);
 	if (IS_ERR(ethtool_rule)) {
 		ret = PTR_ERR(ethtool_rule);
-- 
2.20.1



