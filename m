Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D913AEDA6
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFUQVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhFUQUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A24E611CE;
        Mon, 21 Jun 2021 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292315;
        bh=TLQXXMRgCJYZjDlvNmaC2ZBnYfPNzA9DrlkZNPcYHKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USdokBCq2S36DMkLugXpIjO/2xfnKufgLFfaB09KdDTM+jbpAZ0ACqw9m4cdqL2ps
         VC4u92KlKYA/h0ADXYRoXOEBU2tXovDKpG5KD1wh8qMVsk6pd9eUQtfoDJtbWfCxfE
         srHTLwG/3PaT9vt1xjaxDE3agIss728mfNBXSTH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/90] pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled
Date:   Mon, 21 Jun 2021 18:15:21 +0200
Message-Id: <20210621154905.687271111@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d0f06790d38f..0ba4e4e070a9 100644
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



