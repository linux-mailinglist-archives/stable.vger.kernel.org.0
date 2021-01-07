Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB782EE92A
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbhAGWtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbhAGWtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:49:50 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFF8C0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 14:49:09 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v14so6396391wml.1
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 14:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kresin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBbspZi0InzCAWqAKuWUmxiQ/lqXZTt+DFXtkh8nSVk=;
        b=ohx3twNXChMl+YcJFXiovLick++1jveuCJflQo9dGZq9DzXQePIsVtIsLhwwnNtU04
         +mbA6iQmcjKayfYjb1jNYGllsGdfbfWihoGVuRByySMuRiTLNrSllOZX5kPQc3vS36e3
         VBXm9CxFnAqC89HrsAiRXeekX4UvsQe6miq2Yq/W49ZArkoZANaNIZu2YYVMaVNa/Fy8
         z/pSaQcQeIQ67kF6EBsTJ7esIwdaoEw7ICw3CacZfNaqHMYrkmJEMKIJlIABsLNrNXFC
         d79NW1jVjIGT4QpP0QTE5XM68boiTcfIy2nOkBK4AJzLmXKLOVt9l3ADrqq+urocaFuK
         B1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBbspZi0InzCAWqAKuWUmxiQ/lqXZTt+DFXtkh8nSVk=;
        b=MRGVb2jVq0hbLDSGTuUi/+yVDTvAyxHzRpwCNGt6TYfhqm5Bx0SeOc7xPoCrnpfBbv
         GsaGSLZwd2bRIVp/SALA/lHG7T/RuXG4PkAIUIzESAFbsC20fIc2qoU6XSJU1CTqe2rs
         5g4EHAPVbNWnskLd5SKoRFgTKllxLPfChmU8vsoBS49dTa5HcTHRNAdUB0Ne85V0Kiv9
         7McgubRJ+LE5H8pCk+z0cz+zfgNNqmoDNxAK9GuyZQzfSuBP8ooPcNpWjHCj4PJGiEdi
         zGPGBQYuIYs8nt2tYy/GtdN3raxEedTa+4CP5aM/Wq19esPDSH/dE85/bm+j5LC0A2eM
         AJMw==
X-Gm-Message-State: AOAM5339EvT3IGfR0YYskBNRoAMPPCV+n35KktuEsniNVubl8uYZs+ny
        Tui+yKtTUdq+oMNhAdRilrU1uQ==
X-Google-Smtp-Source: ABdhPJyxEV6t0gp5gqr4zSc7sxWoUJ+O5X5/phvLSNp25Zafv6G3ZdjOlSPZSx2H/3OYbgnrHrjcFg==
X-Received: by 2002:a05:600c:1483:: with SMTP id c3mr553547wmh.87.1610059748145;
        Thu, 07 Jan 2021 14:49:08 -0800 (PST)
Received: from desktop.wvd.kresin.me (p200300ec2f1543005c3547d24e99751a.dip0.t-ipconnect.de. [2003:ec:2f15:4300:5c35:47d2:4e99:751a])
        by smtp.gmail.com with ESMTPSA id u10sm9392800wmd.43.2021.01.07.14.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:49:07 -0800 (PST)
From:   Mathias Kresin <dev@kresin.me>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, stable@vger.kernel.org
Subject: [PATCH] phy: lantiq: rcu-usb2: wait after clock enable
Date:   Thu,  7 Jan 2021 23:49:01 +0100
Message-Id: <20210107224901.2102479-1-dev@kresin.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 65dc2e725286 ("usb: dwc2: Update Core Reset programming flow.")
revealed that the phy isn't ready immediately after enabling it's
clocks. The dwc2_check_core_version() fails and the dwc2 usb driver
errors out.

Add a short delay to let the phy get up and running. There isn't any
documentation how much time is required, the value was chosen based on
tests.

Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Mathias Kresin <dev@kresin.me>
---
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
index a7d126192cf1..29d246ea24b4 100644
--- a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
+++ b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
@@ -124,8 +124,16 @@ static int ltq_rcu_usb2_phy_power_on(struct phy *phy)
 	reset_control_deassert(priv->phy_reset);
 
 	ret = clk_prepare_enable(priv->phy_gate_clk);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "failed to enable PHY gate\n");
+		return ret;
+	}
+
+	/*
+	 * at least the xrx200 usb2 phy requires some extra time to be
+	 * operational after enabling the clock
+	 */
+	usleep_range(100, 200);
 
 	return ret;
 }
-- 
2.25.1

