Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17A14765F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgAXBTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbgAXBRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7572824655;
        Fri, 24 Jan 2020 01:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828662;
        bh=/MsGUyie8WthYfpkbM9zdRl34allauhAsvBE1wCo43A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVBQFW2J0XkQXeSG3lwIH/UnPB8F+068jhJgyZph+h22rtxjRp4pwrc2MHJQqNcNk
         jG3YzrZ0Oot6dZ7SwYhfe7FjIJLHWs5BRQScicVq+9tdocGMc7jXMtKVF08IC57Bvt
         VId4LnjrqL828ZHFhDicGo/hag7PBUi71xh4+Yys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/33] bus: ti-sysc: Fix missing force mstandby quirk handling
Date:   Thu, 23 Jan 2020 20:17:04 -0500
Message-Id: <20200124011708.18232-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 93c60483b5feefced92b869d5f97769495bc6313 ]

Commit 03856e928b0e ("bus: ti-sysc: Handle mstandby quirk and use it for
musb") added quirk handling for mstandby quirk but did not consider that
we also need a quirk variant for SYSC_QUIRK_FORCE_MSTANDBY.

We need to use forced idle mode for both SYSC_QUIRK_SWSUP_MSTANDBY and
SYSC_QUIRK_FORCE_MSTANDBY, but SYSC_QUIRK_SWSUP_MSTANDBY also need to
additionally also configure no-idle mode when enabled.

Fixes: 03856e928b0e ("bus: ti-sysc: Handle mstandby quirk and use it for musb")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 3 ++-
 include/linux/platform_data/ti-sysc.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 6dc9d460e3065..52c2485498109 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -981,7 +981,8 @@ static int sysc_disable_module(struct device *dev)
 		return ret;
 	}
 
-	if (ddata->cfg.quirks & SYSC_QUIRK_SWSUP_MSTANDBY)
+	if (ddata->cfg.quirks & (SYSC_QUIRK_SWSUP_MSTANDBY) ||
+	    ddata->cfg.quirks & (SYSC_QUIRK_FORCE_MSTANDBY))
 		best_mode = SYSC_IDLE_FORCE;
 
 	reg &= ~(SYSC_IDLE_MASK << regbits->midle_shift);
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index 0b93804751444..8cfe570fdece6 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -49,6 +49,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_QUIRK_FORCE_MSTANDBY	BIT(20)
 #define SYSC_MODULE_QUIRK_AESS		BIT(19)
 #define SYSC_MODULE_QUIRK_SGX		BIT(18)
 #define SYSC_MODULE_QUIRK_HDQ1W		BIT(17)
-- 
2.20.1

