Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6EA44B6A7
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344920AbhKIW2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239964AbhKIW0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F381B61989;
        Tue,  9 Nov 2021 22:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496381;
        bh=EUM4+Wtb5NFF1zHEiSOkvZje1syJQS5MIMW/361l0Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP1rl1A5y0FaCMYWBdo2/GzwLjyNNgt1icSHPgwcYs2+GjiVJTy2uGZig/qkTmlBq
         Z3233hQb9/AlyKCDlwLTOsatiq4z7o7BQlbUwy27zC4xb/cHIb+ZrXmnrs/eUpnvbM
         odFkjGTxyyZYhsb/ZNCNw5h28drZasWtQnL6OmIG5Uf9+8evuAbD7n3to2jes06Sf8
         FiLeD1Adip1XuXm6gjhoZ0B4YYKMTw4oeap8QmaNQbR5d6POFmV84KI6dWorYSgaXY
         qj2hyeBjRsppUBjnIVhqTf22XR8BuyAhdc4FExsIalaUlSj4VDmkbIPrpuoNaceiyu
         mO+IR6phpXTKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 19/75] bus: ti-sysc: Use context lost quirk for otg
Date:   Tue,  9 Nov 2021 17:18:09 -0500
Message-Id: <20211109221905.1234094-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index 51f67223d2514..5d1f8b711ebca 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1528,7 +1528,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
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

