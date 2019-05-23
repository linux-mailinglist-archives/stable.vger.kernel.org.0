Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF59D289E6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389195AbfEWTS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388941AbfEWTS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE7920863;
        Thu, 23 May 2019 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639107;
        bh=M43iYBL2/sR04SYtZRTjxjXOqo+J3N4c2fF66lDFwBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz9m9F9/7VwKphUPtql6dY2jDyFIwCH8NTsU9Gsc5UmkM5ul+aToVZrsXDANmIe3/
         oQvQv5yXjYSZqEzn7v+DGQP0fwaGiM9lofBBqliKNOsppVFnzYWxGuUqiqQR6e9hcF
         fPoqEEC0FbdzzSnN5cHDWrYTzys9a+2hzqXfeZOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/114] net: ieee802154: fix missing checks for regmap_update_bits
Date:   Thu, 23 May 2019 21:06:36 +0200
Message-Id: <20190523181740.072873627@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 22e8860cf8f777fbf6a83f2fb7127f682a8e9de4 ]

regmap_update_bits could fail and deserves a check.

The patch adds the checks and if it fails, returns its error
code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mcr20a.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 04891429a5542..fe4057fca83d8 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -539,6 +539,8 @@ mcr20a_start(struct ieee802154_hw *hw)
 	dev_dbg(printdev(lp), "no slotted operation\n");
 	ret = regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL1,
 				 DAR_PHY_CTRL1_SLOTTED, 0x0);
+	if (ret < 0)
+		return ret;
 
 	/* enable irq */
 	enable_irq(lp->spi->irq);
@@ -546,11 +548,15 @@ mcr20a_start(struct ieee802154_hw *hw)
 	/* Unmask SEQ interrupt */
 	ret = regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL2,
 				 DAR_PHY_CTRL2_SEQMSK, 0x0);
+	if (ret < 0)
+		return ret;
 
 	/* Start the RX sequence */
 	dev_dbg(printdev(lp), "start the RX sequence\n");
 	ret = regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL1,
 				 DAR_PHY_CTRL1_XCVSEQ_MASK, MCR20A_XCVSEQ_RX);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
-- 
2.20.1



