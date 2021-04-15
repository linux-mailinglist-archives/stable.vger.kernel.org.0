Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C5C360DB8
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhDOPFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233776AbhDOPBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5C66141A;
        Thu, 15 Apr 2021 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498660;
        bh=Ia2AGff4BGo7uPvZn6BYE9TgzvbUrM1qVxEeDs5Acng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX16jZY1GrfW9Oc706lYDKVkhuAt54Ulix2fkGKw1LTCIWD5CBbpFPnc/YfUcrbxm
         1cYubGPlFl6n2NmFxLAKEa/mFL0ZkK8Q8IcmDiAKrj6KGnMmPnZuMI1CU9TVIPDwrU
         bzRCQV/QJFb4AYKubxq/rWyUkEBcgSFTREiUSkWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 23/25] net: sfp: relax bitrate-derived mode check
Date:   Thu, 15 Apr 2021 16:48:17 +0200
Message-Id: <20210415144413.883930924@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 7a77233ec6d114322e2c4f71b4e26dbecd9ea8a7 upstream.

Do not check the encoding when deriving 1000BASE-X from the bitrate
when no other modes are discovered. Some GPON modules (VSOL V2801F
and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
side.

Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp-bus.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -349,14 +349,13 @@ void sfp_parse_support(struct sfp_bus *b
 	}
 
 	/* If we haven't discovered any modes that this module supports, try
-	 * the encoding and bitrate to determine supported modes. Some BiDi
-	 * modules (eg, 1310nm/1550nm) are not 1000BASE-BX compliant due to
-	 * the differing wavelengths, so do not set any transceiver bits.
+	 * the bitrate to determine supported modes. Some BiDi modules (eg,
+	 * 1310nm/1550nm) are not 1000BASE-BX compliant due to the differing
+	 * wavelengths, so do not set any transceiver bits.
 	 */
 	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-		/* If the encoding and bit rate allows 1000baseX */
-		if (id->base.encoding == SFF8024_ENCODING_8B10B && br_nom &&
-		    br_min <= 1300 && br_max >= 1200)
+		/* If the bit rate allows 1000baseX */
+		if (br_nom && br_min <= 1300 && br_max >= 1200)
 			phylink_set(modes, 1000baseX_Full);
 	}
 


