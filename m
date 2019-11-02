Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5A4ECC52
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 01:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfKBAYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 20:24:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44893 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfKBAYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 20:24:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id q26so8080889pfn.11
        for <stable@vger.kernel.org>; Fri, 01 Nov 2019 17:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LezSatWohHihzh0HhIGiufhnWt/TD8Ia5dOfWYhDmnY=;
        b=eHKbe+UOONcj8qkQTHzjdB9YYIqtDnUbEK2VSdeH95FZDWFVAfOtEc1Oy+JCWXu8hh
         xw05ztBdQFe6LPohjURqTJHPjJ58E+jyhwzeUI/MNCnX7+p1LywE8ZcoT9StWNK400Zm
         bL16uEvikVZD3tbygPl698Yb5b7AW7DtE1XPY3wCFvJTdx8Of+yLO5Ne5FXkdxjuRitt
         NRVq99tAntXAHmKtQRwQ1Qp7HCGRRiwyf4wO/7+2lRPRM8SMAFo1rE75W/PgqI9VBFyd
         GgewgMy5KvCVJDPLk2IV+ayc8DAm1UE/bqJHd364XY7SzUP06ZsLDyUwH7GMqbCV90MX
         x/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LezSatWohHihzh0HhIGiufhnWt/TD8Ia5dOfWYhDmnY=;
        b=tFwVXIb6TCP6CvhHWFggQRg1OJz+N1afO4X9hY0UggU7j3Q8A7C1H5myNoH+UyXS2B
         Rkcifsig1mA1xL3fj/LUO5VXvE9TuBmqnoKvLOVcb6Bi9mOic8KeFaI3/+j3EwOvyT45
         YqPcwyzjnCtnEAsgzY3pfjj+CBlql0SjYjXdEAtOs41uLUNiKuDgnszeYJcW3Qm0FnKa
         vuZ7a9jpDQoDN0tm71FsSkax+74PquhuDYG+6pZy+7tqlR7WXkaJO++aEicYLt7sr3U9
         HyQpY9HkinUI6wPAYp6D+ne0p8qF69Di8/q/qLxfCPvlg3WMlXlcEqulbw98lbOzG+L3
         En8w==
X-Gm-Message-State: APjAAAWJLwwtWM+5NVIS2m4y4Iaij6Wi62t8zGRdNhRI1uSglG1xVxOD
        H6a+CaxI7HQ9mrWazCDdQ4Zogg==
X-Google-Smtp-Source: APXvYqyHLo4acaa9eCPQ/NgX/Aw4ZtDtvPs0Mzt7YxuCoeTrNIOJiDCbToJ+lxt4mDByh+WDd3q+yg==
X-Received: by 2002:a62:1d8d:: with SMTP id d135mr9250453pfd.172.1572654264076;
        Fri, 01 Nov 2019 17:24:24 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w2sm7700833pgr.78.2019.11.01.17.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:24:23 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Date:   Fri,  1 Nov 2019 17:24:20 -0700
Message-Id: <20191102002420.4091061-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
the fixup to only affect the PCIe 2.0 (0x106) and PCIe 3.0 (0x107)
bridges.

Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 3 ++-
 include/linux/pci_ids.h                | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 35f4980480bb..b91abf4d4905 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1441,7 +1441,8 @@ static void qcom_fixup_class(struct pci_dev *dev)
 {
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE20, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE30, qcom_fixup_class);
 
 static struct platform_driver qcom_pcie_driver = {
 	.probe = qcom_pcie_probe,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 21a572469a4e..3d0724ee4d2f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2413,6 +2413,8 @@
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
 #define PCI_VENDOR_ID_QCOM		0x17cb
+#define PCIE_DEVICE_ID_QCOM_PCIE20	0x0106
+#define PCIE_DEVICE_ID_QCOM_PCIE30	0x0107
 
 #define PCI_VENDOR_ID_CDNS		0x17cd
 
-- 
2.23.0

