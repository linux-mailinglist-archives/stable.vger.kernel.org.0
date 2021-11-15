Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2402945260E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245613AbhKPCBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240145AbhKOSF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08BE76328A;
        Mon, 15 Nov 2021 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998178;
        bh=WI7AJqZ6bEBHysmP9KtIs8wWWBEDCJWH3LmEhmQscac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXjviyzcp32nMf2mcpojeIofluOTZg/P4qSu5hbLDjfzKX5hVDrw5l64/ixF4knAf
         YwTmkjRi6ZRHj/j8bV1iHMmW5EKKdkah0uAZRpuywlmysuuqve3wfDx9CEGhTCycGc
         GVyfm//jSI4oYPo87o1LjS1FDpTLqPckoAMs/sHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/575] soc/tegra: Fix an error handling path in tegra_powergate_power_up()
Date:   Mon, 15 Nov 2021 18:02:21 +0100
Message-Id: <20211115165358.145579025@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 0118bd986f902..857354a69c39d 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -705,7 +705,7 @@ static int tegra_powergate_power_up(struct tegra_powergate *pg,
 
 	err = reset_control_deassert(pg->reset);
 	if (err)
-		goto powergate_off;
+		goto disable_clks;
 
 	usleep_range(10, 20);
 
-- 
2.33.0



