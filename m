Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481BD34DA22
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhC2WVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhC2WVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1876196E;
        Mon, 29 Mar 2021 22:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056496;
        bh=qEbXIiiTD2de8QKeiUzSVhvasjIpygLJJz1CG8FeMqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFMeUshdk2jq/WhzfOvq5Nk+9ZO4AKXU3edcQbQzTasYFPkGJ0vdIRm2Zh77cjLf0
         GYkB5u77x5CvrVBIdpwyEdZia035uv8CaqMbBJ8boY0fJRc+k7SJA+5LTWgD/uY5ki
         yy1SP/gxzh2MH6Z1F92wLpNL2VYHKtIMftNiU2sCaJpOuQxfIperyYhekfQzqiSh9x
         qEezVq+yXY+8LufA2DHGafdQ033/oBydIICeqWlyNGUVJF1I15NUO3rij/Ev2k9XY4
         6tQsbRbuJH9+ZO6NkrSjmAk6DnMFlIMvi0Nf6+iMCiGmNJEMr4BfReXrSjhBguvPGK
         k9zWNPxy1+j+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 02/38] bus: ti-sysc: Fix warning on unbind if reset is not deasserted
Date:   Mon, 29 Mar 2021 18:20:57 -0400
Message-Id: <20210329222133.2382393-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a7b5d7c4969aba8d1f04c29048906abaa71fb6a9 ]

We currently get thefollowing on driver unbind if a reset is configured
and asserted:

WARNING: CPU: 0 PID: 993 at drivers/reset/core.c:432 reset_control_assert
...
(reset_control_assert) from [<c0fecda8>] (sysc_remove+0x190/0x1e4)
(sysc_remove) from [<c0a2bb58>] (platform_remove+0x24/0x3c)
(platform_remove) from [<c0a292fc>] (__device_release_driver+0x154/0x214)
(__device_release_driver) from [<c0a2a210>] (device_driver_detach+0x3c/0x8c)
(device_driver_detach) from [<c0a27d64>] (unbind_store+0x60/0xd4)
(unbind_store) from [<c0546bec>] (kernfs_fop_write_iter+0x10c/0x1cc)

Let's fix it by checking the reset status.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index a27d751cf219..3d74f237f005 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3053,7 +3053,9 @@ static int sysc_remove(struct platform_device *pdev)
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	reset_control_assert(ddata->rsts);
+
+	if (!reset_control_status(ddata->rsts))
+		reset_control_assert(ddata->rsts);
 
 unprepare:
 	sysc_unprepare(ddata);
-- 
2.30.1

