Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B399F14555B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgAVNVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbgAVNVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:12 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27552468D;
        Wed, 22 Jan 2020 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699271;
        bh=ic33uoAVKVnzOnT9K0frrp+YlGW8qj6wsHLkx6rMn9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOHMXC6Kzf+X5iF/2Crs36+ol9SK9hqZO2rKPtpzot0Jtl1KmBlOwT6TX6hnq+/qR
         V5rElZ0UO56zB7lkZ5dfhTON7Da5ZLSowNr0MaGGqRr0Iwi/PSMZkEAZbgkeVTbs7G
         RXL7wmaJv+wbcy4LgtHtYkwUMOAvD6R/DfP/CqBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 093/222] ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment
Date:   Wed, 22 Jan 2020 10:27:59 +0100
Message-Id: <20200122092840.396293510@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 4521de30fbb3f5be0db58de93582ebce72c9d44f upstream.

The vdd3p0 LDO's input should be from external USB VBUS directly, NOT
PMIC's power supply, the vdd3p0 LDO's target output voltage can be
controlled by SW, and it requires input voltage to be high enough, with
incorrect power supply assigned, if the power supply's voltage is lower
than the LDO target output voltage, it will return fail and skip the LDO
voltage adjustment, so remove the power supply assignment for vdd3p0 to
avoid such scenario.

Fixes: 93385546ba36 ("ARM: dts: imx6qdl-sabresd: Assign corresponding power supply for LDOs")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -749,10 +749,6 @@
 	vin-supply = <&vgen5_reg>;
 };
 
-&reg_vdd3p0 {
-	vin-supply = <&sw2_reg>;
-};
-
 &reg_vdd2p5 {
 	vin-supply = <&vgen5_reg>;
 };


