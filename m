Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CFB3A854B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhFOPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232420AbhFOPwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C51261921;
        Tue, 15 Jun 2021 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772215;
        bh=l1dslkYCdSUrfbKPHqQMHK4DisTF696U3LOjPeX2WJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buf3xY6ITRh8BV+M1T1/OAzMFooBzaTO5l/g5Z85kBJ/GaC7hnWzoYiqFpQXtSHff
         LcvgWqcX0mG0DV5F8OB7M0AHz//CXZf2I87Of9hsBhfkplLxUeev6Y8oVazuImpSli
         Co3C4eMqe518fH63HpAzBlpupYgtTsbkulvEnCkwDpOfdgNyWYMUMkxgvWRYUg+lcN
         ZguSssikcs77l8XCAmpScuvUIVtYTPPF0hT+LxmV8u6WvR7bG/GTdpZgrQV19O8ZLL
         vFGwKz2burqM7zqjqYLBbSL6PGNOwreeKnIvNznoBQolZIvuY4xjmlb/WTE8DzyUnl
         FinzQKgEsIxpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/12] pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled
Date:   Tue, 15 Jun 2021 11:50:01 -0400
Message-Id: <20210615155009.62894-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155009.62894-1-sashal@kernel.org>
References: <20210615155009.62894-1-sashal@kernel.org>
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
index 80e7067cfb79..ad811c0438cc 100644
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

