Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8195934DB32
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhC2W0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhC2WYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A31C619A0;
        Mon, 29 Mar 2021 22:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056609;
        bh=MxYQJrrkYXo3xLfPUwr3yKL/oc9EhmY0TSkiN6AG4WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHxByrJyibr2TPV9rHXtb7meesD/0/1wdiBRpcPQ6xMlnI6LBC9IsAy50vnpXAEFx
         8IQI56vuhQyZlebOwng0pYbO7bYsG0Tqlb1sj5kykAqknBcsS8WNS9T9E8NRxoQKuv
         Jm2ZsRv1uve6b1khVlcMXXaygIWK/vW5NBdzph4JaGIcAW2u+dCb46pwaX+vts7Ssi
         b/WOe1PgEAUGFRLywAgpbe7T8FR+1mBSp9nVRNtrq10xWQAhiSItsyAvVhCipdFhHU
         P3WsQPPhcqN2IE9nmVDwaUyvdY2gUP3ezX9+IBSSR4lRYoHGg8T669qtZgx8vYiemw
         tQZ/w2FP8FLNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/15] bus: ti-sysc: Fix warning on unbind if reset is not deasserted
Date:   Mon, 29 Mar 2021 18:23:13 -0400
Message-Id: <20210329222327.2383533-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index 54c8c8644df2..b6a278183d82 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1814,7 +1814,9 @@ static int sysc_remove(struct platform_device *pdev)
 
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

