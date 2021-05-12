Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E6B37C3DD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhELPWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhELPUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BC4661429;
        Wed, 12 May 2021 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832122;
        bh=0gAMiszxUcJaObyhwZluX8H5eCjPXEZfl7Orfw5QyHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUa8hrInBkbZ3avcr2nGxn1CQ7t9IMz381HOtRt04CKNoqhlrFd2pBKagp7Svqatn
         61dCiTsNq+7TLmJ0cv0dAaFEIrc5kPKOIg15RwBSAb8b5dxoCoexc09Cofa47q4xBy
         PbqXF1iaDYCBzpj3Mx2bwGFOBVymW56996ZaThsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/530] usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS
Date:   Wed, 12 May 2021 16:44:13 +0200
Message-Id: <20210512144824.525281880@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

[ Upstream commit 19c234a14eafca78e0bc14ffb8be3891096ce147 ]

While interpreting CC_STATUS, ROLE_CONTROL has to be read to make
sure that CC1/CC2 is not forced presenting Rp/Rd.

>From the TCPCI spec:

4.4.5.2 ROLE_CONTROL (Normative):
The TCPM shall write B6 (DRP) = 0b and B3..0 (CC1/CC2) if it wishes
to control the Rp/Rd directly instead of having the TCPC perform
DRP toggling autonomously. When controlling Rp/Rd directly, the
TCPM writes to B3..0 (CC1/CC2) each time it wishes to change the
CC1/CC2 values. This control is used for TCPM-TCPC implementing
Source or Sink only as well as when a connection has been detected
via DRP toggling but the TCPM wishes to attempt Try.Src or Try.Snk.

Table 4-22. CC_STATUS Register Definition:
If (ROLE_CONTROL.CC1 = Rd) or ConnectResult=1)
00b: SNK.Open (Below maximum vRa)
01b: SNK.Default (Above minimum vRd-Connect)
10b: SNK.Power1.5 (Above minimum vRd-Connect) Detects Rp-1.5A
11b: SNK.Power3.0 (Above minimum vRd-Connect) Detects Rp-3.0A

If (ROLE_CONTROL.CC2=Rd) or (ConnectResult=1)
00b: SNK.Open (Below maximum vRa)
01b: SNK.Default (Above minimum vRd-Connect)
10b: SNK.Power1.5 (Above minimum vRd-Connect) Detects Rp 1.5A
11b: SNK.Power3.0 (Above minimum vRd-Connect) Detects Rp 3.0A

Fixes: 74e656d6b0551 ("staging: typec: Type-C Port Controller Interface driver (tcpci)")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20210304070931.1947316-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index f9f0af64da5f..a06da1854c10 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -20,6 +20,15 @@
 
 #define PD_RETRY_COUNT 3
 
+#define tcpc_presenting_cc1_rd(reg) \
+	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
+	 (((reg) & (TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT)) == \
+	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC1_SHIFT)))
+#define tcpc_presenting_cc2_rd(reg) \
+	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
+	 (((reg) & (TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT)) == \
+	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC2_SHIFT)))
+
 struct tcpci {
 	struct device *dev;
 
@@ -174,19 +183,25 @@ static int tcpci_get_cc(struct tcpc_dev *tcpc,
 			enum typec_cc_status *cc1, enum typec_cc_status *cc2)
 {
 	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
-	unsigned int reg;
+	unsigned int reg, role_control;
 	int ret;
 
+	ret = regmap_read(tcpci->regmap, TCPC_ROLE_CTRL, &role_control);
+	if (ret < 0)
+		return ret;
+
 	ret = regmap_read(tcpci->regmap, TCPC_CC_STATUS, &reg);
 	if (ret < 0)
 		return ret;
 
 	*cc1 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC1_SHIFT) &
 				 TCPC_CC_STATUS_CC1_MASK,
-				 reg & TCPC_CC_STATUS_TERM);
+				 reg & TCPC_CC_STATUS_TERM ||
+				 tcpc_presenting_cc1_rd(role_control));
 	*cc2 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC2_SHIFT) &
 				 TCPC_CC_STATUS_CC2_MASK,
-				 reg & TCPC_CC_STATUS_TERM);
+				 reg & TCPC_CC_STATUS_TERM ||
+				 tcpc_presenting_cc2_rd(role_control));
 
 	return 0;
 }
-- 
2.30.2



