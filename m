Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F9912B035
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 02:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfL0B1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 20:27:54 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41435 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfL0B1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Dec 2019 20:27:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so13681612pgk.8
        for <stable@vger.kernel.org>; Thu, 26 Dec 2019 17:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yRlWtIcQUsLKShnJr6O+2Jcc7yVY+hw3WSlirQFQtWs=;
        b=btjOcsmzB3eli/6pjctJta/MabRyX8p1QS6dwLFAxMubblG9fXM8Bf7onRm+8ZDxXU
         SOsq7s5EreR2eT+mDSaLjY61yRlndP8HeEAhUp7ezBMFy+K/way9A54AMsn2JgGuaIuP
         STn5JbYY+xgWbvXLOAOhsosDu3SQrCzB5qDrFaB9EWG3/s1eFdYWVgLMtc+pOSgWM5jX
         EPTGIkidysOVI3UCiTtUw69zbGG8pd+jVt8SE5eTBu8kKWNp/TpmDsU8U67DWKfS41Cj
         K5u8AtWCGBB5hCGLOwSDa4RICEtQshr5kwkVVYNLJRTvh4ent9GFXM8bvRXtVnZnUGfW
         Y6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yRlWtIcQUsLKShnJr6O+2Jcc7yVY+hw3WSlirQFQtWs=;
        b=sv+n+iUq1tdC8MT0h7rGl/2Ref1zIviKi3dQ3ZXq1GlwgsOlLzMpp6V3PIXpfaNfHe
         SEtG+2p5TZRAA27LGYiiHsvki8nl2K+zDglmRc9Tj+ZhiIxre9ENtS9Hxo8raqV+uG6m
         4jV7ubep94Nl84utxU4Zcckw7Otgkr1tbNVeBvow+3hhPTzhSXbSGQabHfpYuRbCduNN
         HsUGq+mm+eB6vcXJ4h9Va8GGTpHZeb2EBpudVtp9zhmPNABiziMo4ek8jpVj/ihTk32k
         K7P81Q4MwpeACPX3Uyyg30SWVUl4c3Gg6BQYFWoboh4yQaK85hkKLLz/q7mpRAfoChnK
         cNCw==
X-Gm-Message-State: APjAAAUg7PFrjXvHe04MEWgucKnOLcacJfnBFbDbQ6v/57S4K3MSoN9I
        AHOQDQHaUG8K+UckTGN/9+/w+w==
X-Google-Smtp-Source: APXvYqxh78dSzfk4bN9uQtL+xMtUE95dpqDcuu+Cy1dcRpt9DnzYP8G4XdfL7ANBtCsLOLGzENG0Bw==
X-Received: by 2002:a63:7311:: with SMTP id o17mr49136128pgc.29.1577410072994;
        Thu, 26 Dec 2019 17:27:52 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id s21sm16769185pfe.20.2019.12.26.17.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:27:52 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marc Gonzalez <marc.w.gonzalez@free.fr>, stable@vger.kernel.org
Subject: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Date:   Thu, 26 Dec 2019 17:27:17 -0800
Message-Id: <20191227012717.78965-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
the fixup to only affect the relevant PCIe bridges.

Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Stan, I picked up all the suggested device id's from the previous thread and
added 0x1000 for QCS404. I looked at creating platform specific defines in
pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
prefer that I do this anyway.

 drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 5ea527a6bd9f..138e1a2d21cc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
 {
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
 
 static struct platform_driver qcom_pcie_driver = {
 	.probe = qcom_pcie_probe,
-- 
2.24.0

