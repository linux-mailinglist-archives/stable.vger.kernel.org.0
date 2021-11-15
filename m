Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A6B450C34
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhKORfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237759AbhKORah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE2863298;
        Mon, 15 Nov 2021 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996793;
        bh=07OHWDNGkTNOsLCGJN+tfUpHn676d9UH7S60NJovHpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9ahK6m2EKahVm63fFSSvACVpiQa3/xcK5Nq4s/OiYDGxei39pdL3OehaOgmeMMT/
         Wp0xSOaa5xL7kc1em3oUbv7yHJyGQ3FlCZn5ulnaOaGX1lpzm+7ec10YrXFzNcRtfL
         B3fqP1wulnC99qC6LOm2axQrVXZHIb0KHFbPyKdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 269/355] soc/tegra: Fix an error handling path in tegra_powergate_power_up()
Date:   Mon, 15 Nov 2021 18:03:13 +0100
Message-Id: <20211115165322.441545354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 986b5094708e508baa452a23ffe809870934a7df ]

If an error occurs after a successful tegra_powergate_enable_clocks()
call, it must be undone by a tegra_powergate_disable_clocks() call, as
already done in the below and above error handling paths of this function.

Update the 'goto' to branch at the correct place of the error handling
path.

Fixes: a38045121bf4 ("soc/tegra: pmc: Add generic PM domain support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 0447afa970f5e..ab75f41e9c0c9 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -591,7 +591,7 @@ static int tegra_powergate_power_up(struct tegra_powergate *pg,
 
 	err = reset_control_deassert(pg->reset);
 	if (err)
-		goto powergate_off;
+		goto disable_clks;
 
 	usleep_range(10, 20);
 
-- 
2.33.0



