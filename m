Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3BE3B3484
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhFXRQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 13:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhFXRQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 13:16:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB74C61166;
        Thu, 24 Jun 2021 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624554865;
        bh=B6qNqvi41h4uc4w9dvtFFFJy8jV4qKdG7ikgRpKBPIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLkdGSyvR8TOsESZ0YrcnHynVuuwEONYjnbM5UhqLq2YRvz3bRLZTAMjelPrgW6PM
         GukC+uMimKNabq/hulkcOnHoT5W/zz4DMkBQJEviy3+OdHjgATKXMiSOOmaBxU6tq+
         NM1rWGstcThPk0+OsfU0kvtpsW86vYt69FvtYSmvd49GbEJ1I4r0BlA17b/6lgZ99G
         eN7xsGW4lFk7D05RZ0n8F3X3Y5txbKWYqpV062nRZBTdIv89wa4zuV1+6Dvj51XXQD
         ZYS/cI+LGMFz9PDVAAVq6KJGO7dAAmDxllAY7JueMhJgYNa5x19orXOZlguBmcJyaO
         4OEJN46rLvw3Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?R=C3=B6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Zachary Zhang <zhangzg@marvell.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA controller
Date:   Thu, 24 Jun 2021 19:14:18 +0200
Message-Id: <20210624171418.27194-2-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624171418.27194-1-kabel@kernel.org>
References: <20210624171418.27194-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ASMedia ASM1062 SATA controller advertises
Max_Payload_Size_Supported of 512, but in fact it cannot handle TLPs
with payload size of 512.

We discovered this issue on PCIe controllers capable of MPS = 512
(Aardvark and DesignWare), where the issue presents itself as an
External Abort. Bjorn Helgaas says:
  Probably ASM1062 reports a Malformed TLP error when it receives a data
  payload of 512 bytes, and Aardvark, DesignWare, etc convert this to an
  arm64 External Abort.

Limiting Max Payload Size to 256 bytes solves this problem.

Signed-off-by: Marek Behún <kabel@kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212695
Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
Cc: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4d9b9d8fbc43..a4ba3e3b3c5e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3239,6 +3239,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
 			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion
-- 
2.31.1

