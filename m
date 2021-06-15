Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002763A84CA
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFOPwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhFOPvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AFE5615A0;
        Tue, 15 Jun 2021 15:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772172;
        bh=fU13to9nu0aO8QZO1mX+8wtj7oG7zYJNoYFpZBMBe8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6wSj44WfOOfrbeKAP4Zbk3/I6L9WH3MkBGBsxSorVMDl/NDFtQqXmrsbG+uFTYrC
         7p1Nzbai8/WVFls17AvR7+LPPOsTjNedUc0kUtFHSLXvslsDKiAM6x81tBDdOkiVdE
         gVS8Ec8i5ooLyX9G4R9guw8QAuaW+Whbl+A6hKpBDepUDCYQNXp5OlzfSg129Hk6QK
         pwB27100XPgsQr0Y8z+uauuAiVlBY78ExKFOb9fqcUwMwRQ8wO5TKuCao0WfXhggMD
         WStC6Kh07r9D3w+5ibRsgiT4cIaIyDTJ7M6fB8Aofp6osBCRy+m5oB2uiUZxlwjclg
         V6ODbdq/4JtoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 19/30] pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled
Date:   Tue, 15 Jun 2021 11:48:56 -0400
Message-Id: <20210615154908.62388-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit eb367d875f94a228c17c8538e3f2efcf2eb07ead ]

In 'rt2880_pmx_group_enable' driver is printing an error and returning
-EBUSY if a pin has been already enabled. This begets anoying messages
in the caller when this happens like the following:

rt2880-pinmux pinctrl: pcie is already enabled
mt7621-pci 1e140000.pcie: Error applying setting, reverse things back

To avoid this just print the already enabled message in the pinctrl
driver and return 0 instead to not confuse the user with a real
bad problem.

Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210604055337.20407-1-sergio.paracuellos@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
index caaf9e34f1ee..09b0b8a16e99 100644
--- a/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
+++ b/drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c
@@ -127,7 +127,7 @@ static int rt2880_pmx_group_enable(struct pinctrl_dev *pctrldev,
 	if (p->groups[group].enabled) {
 		dev_err(p->dev, "%s is already enabled\n",
 			p->groups[group].name);
-		return -EBUSY;
+		return 0;
 	}
 
 	p->groups[group].enabled = 1;
-- 
2.30.2

