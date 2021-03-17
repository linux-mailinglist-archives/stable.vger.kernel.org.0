Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6B33EFEA
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 13:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhCQMA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 08:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhCQMAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 08:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B21464F3E;
        Wed, 17 Mar 2021 11:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615982400;
        bh=xSVBdXu5VPRqnvQvB+ZgwMaBE4RPbLYCP8O+B3jDrpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XS9O7WOpbB3AHU/Zlbo4rooZVcbzMmA5zP5JUCna0khkKLo8SXUU/wAAuhfGhhtWp
         tpn68QwZPtfJylrre9dacscdrIalbEJC7zWbYUqp/vxKQ+J8f7hD+D3MrTv4I8dYw9
         hj/2h9D+IRNhFqtdBYYEhSJweoyd/Gzvg4lK2VuQmCFBzBK+x1S481EpR9/+D8d1dI
         D7CCyFuh/AH7BkBD68n4Res62DS1ca8Hjqy/WlrcVtsB2Gsz/XSY0XmTDKmwDUthhX
         Y4BV1eIAjE2VIoBiB3l+6Ar+NEzQ78qlxF8wsdx0FZYgyt/KSV15K9pWbIs10C78VY
         kifPvH5YIHxEg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA controller
Date:   Wed, 17 Mar 2021 12:59:24 +0100
Message-Id: <20210317115924.31885-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ASMedia ASM1062 SATA controller causes an External Abort on
controllers which support Max Payload Size >= 512. It happens with
Aardvark PCIe controller (tested on Turris MOX) and also with DesignWare
controller (armada8k, tested on CN9130-CRB):

  ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
  ata1.00: ATA-9: WDC WD40EFRX-68WT0N0, 80.00A80, max UDMA/133
  ata1.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 32), AA
  ERROR:   Unhandled External Abort received on 0x80000000 at EL3!
  ERROR:    exception reason=1 syndrome=0x92000210
  PANIC at PC : 0x00000000040273bc

Limiting Max Payload Size to 256 bytes solves this problem.

On Turris MOX this problem first appeared when the pci-aardvark
controller started using the pci-emul-bridge API, in commit 8a3ebd8de328
("PCI: aardvark: Implement emulated root PCI bridge config space").

On armada8k this was always a problem because it has HW root bridge.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
Cc: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/quirks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3ba9e..a561136efb08 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3251,6 +3251,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
 			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
 			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+/*
+ * For some reason DECLARE_PCI_FIXUP_HEADER does not work with pci-aardvark
+ * controller. We have to use DECLARE_PCI_FIXUP_EARLY.
+ */
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion
-- 
2.26.2

