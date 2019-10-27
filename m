Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81D3E688A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbfJ0VaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731390AbfJ0VTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D2BA21848;
        Sun, 27 Oct 2019 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211143;
        bh=HCYxVJDMn2BwZ6tKnFHJdI0Ik6H89eRSiO+FbcLH2wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlNHvomBx/fIz2ef9OI4fAbQvVQHLoNGdl23G3ZH+RvrJe9pwDpXgoX8Zd6OHhBZn
         czt/jQ60lWs7ImsTjOm+tsTW1RpDXXLRM1jvs1z0Eio40XwuBc0K7L8cD79tscrsbI
         1x4bMs/D30zlY1aXTzxujj/KN4rRY+uhRZlgmJy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo <yzhai003@ucr.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 048/197] net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()
Date:   Sun, 27 Oct 2019 21:59:26 +0100
Message-Id: <20191027203354.290448834@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>

[ Upstream commit 53de429f4e88f538f7a8ec2b18be8c0cd9b2c8e1 ]

In function mdio_sc_cfg_reg_write(), variable "reg_value" could be
uninitialized if regmap_read() fails. However, "reg_value" is used
to decide the control flow later in the if statement, which is
potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 3e863a71c5136..7df5d7d211d47 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -148,11 +148,15 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
 {
 	u32 time_cnt;
 	u32 reg_value;
+	int ret;
 
 	regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
 
 	for (time_cnt = MDIO_TIMEOUT; time_cnt; time_cnt--) {
-		regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		ret = regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
+		if (ret)
+			return ret;
+
 		reg_value &= st_msk;
 		if ((!!check_st) == (!!reg_value))
 			break;
-- 
2.20.1



