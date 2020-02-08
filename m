Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012B91566F9
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgBHSi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:38:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33638 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727653AbgBHS3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-0003cH-Ll; Sat, 08 Feb 2020 18:29:33 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-000CKe-EW; Sat, 08 Feb 2020 18:29:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrew Murray" <andrew.murray@arm.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Steffen Liebergeld" <steffen.liebergeld@kernkonzept.com>
Date:   Sat, 08 Feb 2020 18:19:27 +0000
Message-ID: <lsq.1581185940.117103824@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 028/148] PCI: Fix Intel ACS quirk UPDCR register address
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>

commit d8558ac8c93d429d65d7490b512a3a67e559d0d4 upstream.

According to documentation [0] the correct offset for the Upstream Peer
Decode Configuration Register (UPDCR) is 0x1014.  It was previously defined
as 0x1114.

d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
intended to enforce isolation between PCI devices allowing them to be put
into separate IOMMU groups.  Due to the wrong register offset the intended
isolation was not fully enforced.  This is fixed with this patch.

Please note that I did not test this patch because I have no hardware that
implements this register.

[0] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf (page 325)
Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
Link: https://lore.kernel.org/r/7a3505df-79ba-8a28-464c-88b83eefffa6@kernkonzept.com
Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3787,7 +3787,7 @@ int pci_dev_specific_acs_enabled(struct
 #define INTEL_BSPR_REG_BPPD  (1 << 9)
 
 /* Upstream Peer Decode Configuration Register */
-#define INTEL_UPDCR_REG 0x1114
+#define INTEL_UPDCR_REG 0x1014
 /* 5:0 Peer Decode Enable bits */
 #define INTEL_UPDCR_REG_MASK 0x3f
 

