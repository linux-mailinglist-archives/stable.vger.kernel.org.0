Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAFE28B7B1
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389803AbgJLNp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389764AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A29C2236F;
        Mon, 12 Oct 2020 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510331;
        bh=RLpye4EcUIzShnz8HPng4InVuZGK7edn+R2ab7m3ZbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1752NQc6AiVAOw/cuvQUyQn0nzvpQsm4Qi+fTZHBDWFQEDPgzWIpCcaekiEjS1St
         r/chCfvTR2ug7P+fU75XisSDV/niGGkPIMpUh3OLVzy8CaO30dTqYZ3cqSIMPXqOo9
         WXFm7phGL0VnfuKeWIxIFHsaccBgSSS/cUWh+L38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 023/124] r8169: consider that PHY reset may still be in progress after applying firmware
Date:   Mon, 12 Oct 2020 15:30:27 +0200
Message-Id: <20201012133147.968927830@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 47dda78671a3d5cee3fb2229e37997d2ac8a3b54 upstream.

Some firmware files trigger a PHY soft reset and don't wait for it to
be finished. PHY register writes directly after applying the firmware
may fail or provide unexpected results therefore. Fix this by waiting
for bit BMCR_RESET to be cleared after applying firmware.

There's nothing wrong with the referenced change, it's just that the
fix will apply cleanly only after this change.

Fixes: 89fbd26cca7e ("r8169: fix firmware not resetting tp->ocp_base")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/r8169_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2113,11 +2113,18 @@ static void rtl_release_firmware(struct
 
 void r8169_apply_firmware(struct rtl8169_private *tp)
 {
+	int val;
+
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
 	if (tp->rtl_fw) {
 		rtl_fw_write_firmware(tp, tp->rtl_fw);
 		/* At least one firmware doesn't reset tp->ocp_base. */
 		tp->ocp_base = OCP_STD_PHY_BASE;
+
+		/* PHY soft reset may still be in progress */
+		phy_read_poll_timeout(tp->phydev, MII_BMCR, val,
+				      !(val & BMCR_RESET),
+				      50000, 600000, true);
 	}
 }
 


