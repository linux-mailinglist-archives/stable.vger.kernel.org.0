Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24B7292BF3
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgJSQ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 12:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgJSQ4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 12:56:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4604FC0613CE;
        Mon, 19 Oct 2020 09:56:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i1so559992wro.1;
        Mon, 19 Oct 2020 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PYh9zOEyCKmAv70piA7xO/5F+a+eOAGeDMzmq6LTgU=;
        b=e2v4xWqR0zmlnm2YqD0yptlm8H/vyT2xIG9OhDne1W9sxkxfzWV0pQXmdt34eTxALR
         G3egG9E0KIO/LFHh416TY6bGdH26j7//issKq0+VcjVcOIDy2dXzWORWbERx0IPT+TLV
         Yhde/k+Bzl319BWbZZ0zo8yfJVPwLGYq7w7h9vsP/k2gGvmb7WBmtB9v2l1582tqYHWQ
         BvGZGx3r7iNZM6x1mI4wY6oJDdxLggLRTt58x0MQj2+LiF7iCJWNSsRPm3HaVXGapSsR
         WSpenueZpYchbcPlcH+kgumIDXTTcd/p3uByWf8HKB0mpOmNJRLE6S9j4Xl32HQvxCUe
         F0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9PYh9zOEyCKmAv70piA7xO/5F+a+eOAGeDMzmq6LTgU=;
        b=aFzZTDgJG2PlphV+pmY2XMwOqZvdd0tJlBgtCtw032Na53keC5uZKfHUxixXm7jcIU
         UegdF/DRQfuxvzVCk3TgtsNjchhjgp7ma72q5+M0Bexsuu9xOYAKxGiVIIah3TTCn1pF
         TwU7M9sMCyBiXgZ/Nv/Lg0WJYNR8RYBuBS6TfMm+7wnGibaix3s1XREaiPMzR9CBbynt
         3lPYeoSAwVrpSB0wNs2b2llspVowISbT/eY6tEFOg0IBp6caf2wY67FW51Lxwva/BTzp
         ZUXrJ9cVH2cnkyqVnDnBzOlCBoNDPZdr0gL03Rk4c0CGUi7M66Q2sYCBqmqqKHFiq9dP
         amFQ==
X-Gm-Message-State: AOAM530YtTZh1xLQRksva9jx7xkuqLY/md4J4PEvtx/xOTqS9OJPL521
        1RaWKmZn7VXsq6e70MSHtJ+8RC6/DCn5eg==
X-Google-Smtp-Source: ABdhPJzNrVvlnKmQjLdC1PIVPbVtvAUgSiH/bDPFBKMZqEbpxG+44idgNxVAcHv/cn2n/pRoO0gRfA==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr185200wrx.246.1603126563897;
        Mon, 19 Oct 2020 09:56:03 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id 4sm412706wrn.48.2020.10.19.09.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 09:56:03 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     lorenzo.pieralisi@arm.com
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
Subject: [RESEND PATCH] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
Date:   Mon, 19 Oct 2020 18:55:55 +0200
Message-Id: <20201019165555.8269-1-ansuelsmth@gmail.com>
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

