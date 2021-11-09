Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C5844B77A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbhKIWfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344706AbhKIWcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D6461AA6;
        Tue,  9 Nov 2021 22:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496489;
        bh=PHl1RkukXVaPK0y0mbpdmnDqGbEifPQa37Ms8/gr4Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG2WZS6lU6BFmbUtfKpsUAgWLUF1+7xlFOgYK7ycDxDpnDQRmihVtM9g5HB6H+3Bz
         JiLZ+NYvNDPtSKgIcONQiOqwg/HlZowPiYQE/30AxIsHdw9RKu3q6Fo1AzKqKLR3Hw
         c68oRFbtQBE3iBAzA3rCXqPmaQQKUe1eeSKjodao/ae0fky/o6/M4MK1AZtBVq1sTx
         qWzd8gxAbTPdDaoQWERokRtbuChD2n0tftnlz7aMNKd39TPZ1/g+xX4HWxbIOWIijA
         2iT0+HSovwJv7Gz3SGpZz6XoOQDRKJD1uawWwuZnrWNuf+dFx1dzsKqKM1IdQr+95f
         7UK0TzEzq+Zyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 15/50] bus: ti-sysc: Use context lost quirk for otg
Date:   Tue,  9 Nov 2021 17:20:28 -0500
Message-Id: <20211109222103.1234885-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9067839ff45a528bcb015cc2f24f656126b91e3f ]

Let's use SYSC_QUIRK_REINIT_ON_CTX_LOST quirk for am335x otg instead of
SYSC_QUIRK_REINIT_ON_RESUME quirk as we can now handle the context loss
in a more generic way.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 5876293d493a9..a9be1f7bbc49a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1523,7 +1523,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -ENODEV, 0x4ea2080d, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY |
-		   SYSC_QUIRK_REINIT_ON_RESUME),
+		   SYSC_QUIRK_REINIT_ON_CTX_LOST),
 	SYSC_QUIRK("wdt", 0, 0, 0x10, 0x14, 0x502a0500, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_WDT),
 	/* PRUSS on am3, am4 and am5 */
-- 
2.33.0

