Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AF014E22D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgA3Sqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731219AbgA3Sqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:46:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC41B205F4;
        Thu, 30 Jan 2020 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409993;
        bh=N79B2Sl0u8IhEa4tfI7TKLJISHSBJ0Ww85eqLqI6MH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bqh1UWauUcB3wadjGljWUaOuv3BXekaok9iXJzvcp5aWInG+xszJutDrBCuu50bBi
         uGSlATbjzyag7m82+RgZp2qTu5wEPTqKfANM4bKPhjoSEfiteyUewP9X7UmLD15jwv
         CLXyVkG4wcTMuCJlQWsGmNyHeGtt6ZHXTCFkPsgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/110] bus: ti-sysc: Fix missing force mstandby quirk handling
Date:   Thu, 30 Jan 2020 19:39:15 +0100
Message-Id: <20200130183625.500290109@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ea16a2d4fb532..d9846265a5cd9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -987,7 +987,8 @@ static int sysc_disable_module(struct device *dev)
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



