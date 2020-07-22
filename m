Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CD228DEE
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 04:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgGVCTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 22:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgGVCTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 22:19:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AABAC061794;
        Tue, 21 Jul 2020 19:19:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k27so397425pgm.2;
        Tue, 21 Jul 2020 19:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wV7qhzZv3sbD4+KlzCK0zK14sIgrZ5cvRZxkccSQFE=;
        b=hs7r6WmJiGZaRzMcj/QB6p0Qh7iJvLcLJvjwlInb0zYm6qRskYLKwviZ8EiP/3mmWZ
         fvn6G4N481ZG3jla5XGocLKM/bAtJaDD8K7dX3ADizZygeTZg23SrewAUvcwmeWYbQ9M
         F08xMcrfmzxbPqMWY61CkRe0LfsO7+erliQ7+SLASCoaC75iptIUdfNtYalJVQkkjzb/
         FWyujWLlOyNrpCdGKAHjo72HmWGifFoN7drdyhAcVKKlBWRUA2ZJcXIEm44PQuhgo4k+
         /DIqEkq7nozbSbvS6rQm6IOsjX1jE2GOZ8RmWmqNglcm2n7sHcv5yPXq3EsQ+SkplbVr
         EVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wV7qhzZv3sbD4+KlzCK0zK14sIgrZ5cvRZxkccSQFE=;
        b=kqVL4Eml3DObIcl/PSbJyqXNwGBIN47b9qjPgXzNxT5vgZkkhLDHVlMxnQrH4mnHGn
         8OX4J2AcaWNO50LkEedjX+lj03uwDt96Z9L9pY3elqadxAf/PW9xpgysZoOddMbckvPI
         wY6Dv7QSiHKzj1TUqeqhC30RQUSmAJcFcBD3MceaMbX/dOMX9SylZOYllEwbzJVMFZsY
         Ym2F2dgGahxqEa6zM3Df+LOYmpX0lX2i87Cef8qKUEmGbZg7PUA4PHAkjNL7KJO6kZf1
         0u0w4Cr4T/0wLfcjZ2ufITTq0HIFweF5NQTPN/buTZI1UTh2qRN13wBcuPNk8mSbt6DJ
         7TGg==
X-Gm-Message-State: AOAM533XjOG77rogxIW2H7Bt9X5Rm88VlHmzoJt8syfDupnNaNVd9isY
        ibTAcJl4DA11W+4eWp62dI1giizMom0=
X-Google-Smtp-Source: ABdhPJwco5bqHMdH+WElYnXoVzzywA0mbkIqRlI/FiDiOZLhyQ1sx13ZUtCN1IGbQ2tIzggG4hRLhA==
X-Received: by 2002:a63:6dc1:: with SMTP id i184mr24987085pgc.345.1595384384680;
        Tue, 21 Jul 2020 19:19:44 -0700 (PDT)
Received: from haswell.lan ([2604:3d09:e37f:fce0::d4a])
        by smtp.gmail.com with ESMTPSA id n2sm344237pfq.140.2020.07.21.19.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 19:19:43 -0700 (PDT)
From:   Robert Hancock <hancockrwd@gmail.com>
To:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Robert Hancock <hancockrwd@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI bridge
Date:   Tue, 21 Jul 2020 20:18:03 -0600
Message-Id: <20200722021803.17958-1-hancockrwd@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently ASPM handling was changed to no longer disable ASPM on all
PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
devices don't seem to function properly with ASPM enabled, as they
cause the parent PCIe root port to cause repeated AER timeout errors.
In addition to flooding the kernel log, this also causes the machine
to wake up immediately after suspend is initiated.

Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges")
Cc: stable@vger.kernel.org
Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
---
 drivers/pci/quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 812bfc32ecb8..e5713114f2ab 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2330,6 +2330,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f1, quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
 
+static void quirk_disable_aspm_l0s_l1(struct pci_dev *dev)
+{
+	pci_info(dev, "Disabling ASPM L0s/L1\n");
+	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+}
+
+/*
+ * ASM1083/1085 PCIe-PCI bridge devices cause AER timeout errors on the
+ * upstream PCIe root port when ASPM is enabled. At least L0s mode is affected,
+ * disable both L0s and L1 for now to be safe.
+ */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x1080, quirk_disable_aspm_l0s_l1);
+
 /*
  * Some Pericom PCIe-to-PCI bridges in reverse mode need the PCIe Retrain
  * Link bit cleared after starting the link retrain process to allow this
-- 
2.26.2

