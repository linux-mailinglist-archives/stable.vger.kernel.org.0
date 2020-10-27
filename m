Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B529B458
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775120AbgJ0PBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766984AbgJ0PA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB88622264;
        Tue, 27 Oct 2020 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810857;
        bh=wtsYNTNiMBabdnx6uyZcAbsHDJZMl69FfYIawJAhTCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3dy+eD8/rsOBLLNLlDg5AskTkabjaesW2o9N3qJtxRbAIUEliw1DvogKb52+2aQf
         wB/23JdWxDpotvz1qxUTOGP/YTshQ+EzYvUxqlaAsWFwSLk9+/7ygCEbaJFBXGGIMx
         wEmeVvbaJlFxDs0EEGkq437ow7nIwj7rqlHYwaHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Johnny Huang <johnny_huang@aspeedtech.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 288/633] pinctrl: aspeed: Use the right pinconf mask
Date:   Tue, 27 Oct 2020 14:50:31 +0100
Message-Id: <20201027135536.178220421@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit 1d6db5ae6b090d1a8edfcb36b9bf47c5f4fe27f6 ]

The Aspeed pinconf data structures are split into 'conf' and 'map'
types, where the 'conf' struct defines which register and bitfield to
manipulate, while the 'map' struct defines what value to write to
the register and bitfield.

Both structs have a mask member, and the wrong mask was being used to
tell the regmap which bits to update.

A todo is to look at whether we can remove the mask from the 'map'
struct.

Fixes: 5f52c853847f ("pinctrl: aspeed: Use masks to describe pinconf bitfields")
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Cc: Johnny Huang <johnny_huang@aspeedtech.com>
Link: https://lore.kernel.org/r/20200910025631.2996342-3-andrew@aj.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index b625a657171e6..11e27136032b9 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -515,7 +515,7 @@ int aspeed_pin_config_set(struct pinctrl_dev *pctldev, unsigned int offset,
 		val = pmap->val << __ffs(pconf->mask);
 
 		rc = regmap_update_bits(pdata->scu, pconf->reg,
-					pmap->mask, val);
+					pconf->mask, val);
 
 		if (rc < 0)
 			return rc;
-- 
2.25.1



