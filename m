Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D03B22EF3D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgG0OOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbgG0OOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:14:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8497D208E4;
        Mon, 27 Jul 2020 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859279;
        bh=FqV7naqdE+WXYz3j7X7YOjTCWWaUZ3mIg+maH9TaCt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcbaWfvKc/FrPhPzfkjb7TDZcWkPfL6yvcMMXIh7gP3GqjOM+fMU1tfhjckKiwEOh
         K8b9/QdhTrO9SQiWIn54jfxS7qoX971TRJR9hmS4wW2X4aZH3CqO6xB3ZIgEWFJnH2
         3lm0Al/WrpCvTeOaoYDyAhEMMvhXabFVWkp8Ncs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Mans Rullgard <mans@mansr.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/138] drm: sun4i: hdmi: Fix inverted HPD result
Date:   Mon, 27 Jul 2020 16:04:02 +0200
Message-Id: <20200727134927.707753132@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit baa1841eb797eadce6c907bdaed7cd6f01815404 ]

When the extra HPD polling in sun4i_hdmi was removed, the result of
HPD was accidentally inverted.

Fix this by inverting the check.

Fixes: bda8eaa6dee7 ("drm: sun4i: hdmi: Remove extra HPD polling")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Mans Rullgard <mans@mansr.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200711011030.21997-1-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
index 63b4de81686ac..4acdfa6087751 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -263,7 +263,7 @@ sun4i_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	unsigned long reg;
 
 	reg = readl(hdmi->base + SUN4I_HDMI_HPD_REG);
-	if (reg & SUN4I_HDMI_HPD_HIGH) {
+	if (!(reg & SUN4I_HDMI_HPD_HIGH)) {
 		cec_phys_addr_invalidate(hdmi->cec_adap);
 		return connector_status_disconnected;
 	}
-- 
2.25.1



