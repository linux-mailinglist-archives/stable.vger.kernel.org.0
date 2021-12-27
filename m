Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1F48001F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbhL0PnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239125AbhL0PlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B2DC061763;
        Mon, 27 Dec 2021 07:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B289E610D5;
        Mon, 27 Dec 2021 15:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C9CC36AE7;
        Mon, 27 Dec 2021 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619622;
        bh=ReYy85jiYZ/+KiGfRtWExOJX8DUt6zBXhIAFkI013BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfKSNwBXR6rWJWC5JSTc7g1usAsZul2PEWrJRPXRV4fIUu1NRs+qkDIFJ3t9dEqva
         0+w9NcvcgkSEcOIJNm4qRLYxyAZi49qG010ljTkCekJenFlTgtAdxw+D63GwvmHoTg
         z2R2yk0XneAf1utA5bc7LuP6b6Vl4/2ypsPuPOKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/128] bus: sunxi-rsb: Fix shutdown
Date:   Mon, 27 Dec 2021 16:29:47 +0100
Message-Id: <20211227151331.913344418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 017a716e7b0e9d4ac06a4d7779bd04fca009bbc9 ]

Function sunxi_rsb_hw_exit() is sometimes called with pm runtime
disabled, so in such cases pm_runtime_resume() will fail with -EACCES.

Instead of doing whole dance of enabling pm runtime and thus clock just
to disable it again immediately, just check if disabling clock is
needed. That way calling pm_runtime_resume() is not needed at all.

Fixes: 4a0dbc12e618 ("bus: sunxi-rsb: Implement runtime power management")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20211121083537.612473-1-jernej.skrabec@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 6f225dddc74f4..4566e730ef2b8 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -687,11 +687,11 @@ err_clk_disable:
 
 static void sunxi_rsb_hw_exit(struct sunxi_rsb *rsb)
 {
-	/* Keep the clock and PM reference counts consistent. */
-	if (pm_runtime_status_suspended(rsb->dev))
-		pm_runtime_resume(rsb->dev);
 	reset_control_assert(rsb->rstc);
-	clk_disable_unprepare(rsb->clk);
+
+	/* Keep the clock and PM reference counts consistent. */
+	if (!pm_runtime_status_suspended(rsb->dev))
+		clk_disable_unprepare(rsb->clk);
 }
 
 static int __maybe_unused sunxi_rsb_runtime_suspend(struct device *dev)
-- 
2.34.1



