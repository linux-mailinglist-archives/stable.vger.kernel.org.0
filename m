Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D46451462
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349176AbhKOUE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344339AbhKOTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BFA63665;
        Mon, 15 Nov 2021 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002566;
        bh=rk5rpRFj1fLQeTIoA5iasSizulQBL7k5SqxUwypkusw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p34mCCxJxLPS/jQtJVwoPOwH+5T1GaMLuoQp1Ef+9X6XqQNyQyIF10p/z1dVX8QTy
         6dkKF8Ibqf1mUEVMsU994UCXJypv/tPAPKXnUUU0Jy6Z2GetEIOnG6o8eVJi1j/5qZ
         HFsIyC7I1FvjZeEVAhCapMXZ6JenIL+7eHdkzUBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/917] soc/tegra: Fix an error handling path in tegra_powergate_power_up()
Date:   Mon, 15 Nov 2021 18:01:51 +0100
Message-Id: <20211115165449.689261250@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 50091c4ec9481..a60e142ade344 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -782,7 +782,7 @@ static int tegra_powergate_power_up(struct tegra_powergate *pg,
 
 	err = reset_control_deassert(pg->reset);
 	if (err)
-		goto powergate_off;
+		goto disable_clks;
 
 	usleep_range(10, 20);
 
-- 
2.33.0



