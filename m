Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8056127A456
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 00:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgI0WBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 18:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgI0WBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Sep 2020 18:01:02 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF33FC0613CE;
        Sun, 27 Sep 2020 15:01:01 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a9so5084389wmm.2;
        Sun, 27 Sep 2020 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PYh9zOEyCKmAv70piA7xO/5F+a+eOAGeDMzmq6LTgU=;
        b=duHzLi7FajhOJGaiNZP2BGpTLfA0z9VPSWRVlAm6MVY8pZhpRbRqnAtDjD7f17nd4G
         cSpv5eJdGfoSjwQLUx+z0mC/5QOcREqdt1spddn3sS/tpNFzSHDCpWIK3m3SUqBX0iav
         IMrhcaqeDh8YisTM1vAVIAs4iBEH1sHHtf5Wn+jUJonIrnDYP4DwU1LgwGMhyqGORNlw
         lN4gXYcs2Lvq+lEPN1GSeL86Ue0yxWARpwvG/PmDctRy4EkQjWH26s9jmOas7TF+mt3Z
         1NyzF+bg+jlg4zYO+dSpb9094njEXuHc01qnYlNNwI9dYcWqLIiE3wzag0ghbe2QjiQK
         vSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PYh9zOEyCKmAv70piA7xO/5F+a+eOAGeDMzmq6LTgU=;
        b=pe9Ai8VCKxlWQcRC9jaGvdDnW7k3QOgVlWZN6S1jJ5BLdEZhrV3g+qqSc+57N+nJw0
         djcaXPUAZnp1JHlCW2SlAHlmSXqNioGFgsgM6IA4U0BRA/2CXV86dhd3lPCtkDMri/2S
         bf+Jc7ZuxNtXTRJE9F6wHbGe0RGvzwKYupPICSZivE2W1jccDRSqduQ/imt9Fle45nT1
         Vr1H8VfZY23sIduuk7eDQyykiwQywNHcfLQUsCcIyYhIDjfRjjEQCqF9iJD/6cunJUj/
         i8UQfvrUX+j0uLcLt5VoXARvxluH40fhEAARwHhPTtZIzSqJmvSRUa54Fq/zSgEoh/GQ
         2CuA==
X-Gm-Message-State: AOAM5327kV5PwjB0UB5keMmg5rh/sdHtWwIY6WctYduAamrsrDJYd0yY
        aupienvMV+XyBZtfyulcHApY4n6gAUNd4g==
X-Google-Smtp-Source: ABdhPJzCVHlLwwuaO0c74jXnittihkW6Wpt/gODmZ4sWhulUYBYw61c+WMVbx0Qn9YVh7eRgUJFmwQ==
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr8559604wmj.172.1601244060486;
        Sun, 27 Sep 2020 15:01:00 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id x17sm4123584wrg.57.2020.09.27.15.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 15:00:59 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
Date:   Mon, 28 Sep 2020 00:00:50 +0200
Message-Id: <20200927220050.448-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The use of PHY_REFCLK_USE_PAD introduced a regression for apq8064
devices. It was tested that while apq doesn't require the padding, ipq
SoC must use it or the kernel hangs on boot.

Fixes: de3c4bf6489 ("PCI: qcom: Add support for tx term offset for rev 2.1.0")
Reported-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 3aac77a295ba..dad6e9ce66ba 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -387,7 +387,9 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
-	val &= ~PHY_REFCLK_USE_PAD;
+	/* USE_PAD is required only for ipq806x */
+	if (!of_device_is_compatible(node, "qcom,pcie-apq8064"))
+		val &= ~PHY_REFCLK_USE_PAD;
 	val |= PHY_REFCLK_SSP_EN;
 	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
 
-- 
2.27.0

