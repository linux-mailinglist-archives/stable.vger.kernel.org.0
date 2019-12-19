Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270B7126B37
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbfLSSyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbfLSSyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48C9206EC;
        Thu, 19 Dec 2019 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781685;
        bh=013ivD8D8TgY1MwfE7exK7iW2v5s1rdQgP4by8x2mmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUtp7aFu4Ylv6G3ggmJQXWTpqS1100yajqHHF70D34QZCXLKGzOXXsqTzGIy1BBKd
         prY8McVzZLl5eS1HZECIpx3Ix+Ps9zJQicJcmrQu1UFv5LksDEzI6ACHovbsBED8AB
         UxYAvN+fKNXIDVy5futiuQZhoyEidlvdlOqj/Iu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 5.4 09/80] PCI: Fix Intel ACS quirk UPDCR register address
Date:   Thu, 19 Dec 2019 19:34:01 +0100
Message-Id: <20191219183042.251734591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org	# v3.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4706,7 +4706,7 @@ int pci_dev_specific_acs_enabled(struct
 #define INTEL_BSPR_REG_BPPD  (1 << 9)
 
 /* Upstream Peer Decode Configuration Register */
-#define INTEL_UPDCR_REG 0x1114
+#define INTEL_UPDCR_REG 0x1014
 /* 5:0 Peer Decode Enable bits */
 #define INTEL_UPDCR_REG_MASK 0x3f
 


