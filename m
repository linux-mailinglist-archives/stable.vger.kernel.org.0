Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4498F641F
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfKJC5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9275821D7E;
        Sun, 10 Nov 2019 02:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354047;
        bh=5WJiAT5XHNPt7tsfOK7uUb9wu5fkg7bQm1JKF/rfFXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htae9CG/V8tU01e40/ry287Av2FeYnUsnglYFokD7+pyVYTQyYFSFTQORu1QHrrXG
         cwSQJBfx9lMBpGx/DotzNv6I+WFxkVSPXHrTzPWFFQs/cfU2nZe1HPGsud9nhzvCnR
         aN5ufz8xYYGMnZ/2AfBjbOC/KBpUbvuN+p+VYI/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 058/109] phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs
Date:   Sat,  9 Nov 2019 21:44:50 -0500
Message-Id: <20191110024541.31567-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 09938ea9d136243e8d1fed6d4d7a257764f28f6d ]

This patch fixes and issue that the vbus_ctrl is disabled by
rcar_gen3_init_from_a_peri_to_a_host(), so a usb host cannot
supply the vbus.

Note that this condition will exit when the otg irq happens
even if we don't apply this patch.

Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index e8fe80312820d..7f5e36bfeee8d 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -195,7 +195,7 @@ static void rcar_gen3_init_from_a_peri_to_a_host(struct rcar_gen3_chan *ch)
 	val = readl(usb2_base + USB2_OBINTEN);
 	writel(val & ~USB2_OBINT_BITS, usb2_base + USB2_OBINTEN);
 
-	rcar_gen3_enable_vbus_ctrl(ch, 0);
+	rcar_gen3_enable_vbus_ctrl(ch, 1);
 	rcar_gen3_init_for_host(ch);
 
 	writel(val | USB2_OBINT_BITS, usb2_base + USB2_OBINTEN);
-- 
2.20.1

