Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA410165C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731913AbfKSFw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbfKSFw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CE720721;
        Tue, 19 Nov 2019 05:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142746;
        bh=5WJiAT5XHNPt7tsfOK7uUb9wu5fkg7bQm1JKF/rfFXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4BK/dZDKme5aY2wp/OdB7kRKppazbA+WkwdkrPIKFVFvOkBSzzFyaiMpIx28f7CG
         w8tk5ZjlhjE+X/TyPwz235GP03LegUm5TZiR5+0Fv2yO3hE9vTfQHEKCXYnF1cgR+u
         rvabx/aMQWZ0u+RBIeFZ2lK9jktNZ08JlmWvdimQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 187/239] phy: renesas: rcar-gen3-usb2: fix vbus_ctrl for role sysfs
Date:   Tue, 19 Nov 2019 06:19:47 +0100
Message-Id: <20191119051335.261452229@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



