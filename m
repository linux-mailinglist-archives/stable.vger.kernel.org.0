Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B12247145
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389918AbgHQSXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388239AbgHQQDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:03:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C198C20748;
        Mon, 17 Aug 2020 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680203;
        bh=q+QfyaXSpXN9HgbBx/BjVOesXDBa5AiVB38a/odz+Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukKtqi+ayo0w2sFDE6RB9RCO/5LbBipwmotXUZZN/GJ4UXT9qh7fpZB5QolMhbCPr
         CnE4Y/xvGBFt/Ydco4aGhhcnW2t2EHTwdNdka8GjFvf63E+0v2BGoimhm+kjeMOEpT
         +Yja9NzcC2FYN25y+QQIz9QHtzqY7PP0VzGAIa0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/270] drm/bridge: ti-sn65dsi86: Clear old error bits before AUX transfers
Date:   Mon, 17 Aug 2020 17:14:52 +0200
Message-Id: <20200817143800.292421968@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit baef4d56195b6d6e0f681f6eac03d8c6db011d34 ]

The AUX channel transfer error bits in the status register are latched
and need to be cleared.  Clear them before doing our transfer so we
don't see old bits and get confused.

Without this patch having a single failure would mean that all future
transfers would look like they failed.

Fixes: b814ec6d4535 ("drm/bridge: ti-sn65dsi86: Implement AUX channel")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200508163314.1.Idfa69d5d3fc9623083c0ff78572fea87dccb199c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 0a580957c8cf1..f1de4bb6558ca 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -647,6 +647,12 @@ static ssize_t ti_sn_aux_transfer(struct drm_dp_aux *aux,
 				     buf[i]);
 	}
 
+	/* Clear old status bits before start so we don't get confused */
+	regmap_write(pdata->regmap, SN_AUX_CMD_STATUS_REG,
+		     AUX_IRQ_STATUS_NAT_I2C_FAIL |
+		     AUX_IRQ_STATUS_AUX_RPLY_TOUT |
+		     AUX_IRQ_STATUS_AUX_SHORT);
+
 	regmap_write(pdata->regmap, SN_AUX_CMD_REG, request_val | AUX_CMD_SEND);
 
 	ret = regmap_read_poll_timeout(pdata->regmap, SN_AUX_CMD_REG, val,
-- 
2.25.1



