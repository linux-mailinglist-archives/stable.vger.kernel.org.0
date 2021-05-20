Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209E938A692
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhETK2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236413AbhETK0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B8161C25;
        Thu, 20 May 2021 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504213;
        bh=6G7tz6cxg/TnwXPla/UCD0PshnpgXKlMGDz99ngo7rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boIpSp9mRItG/dCWhANDljbRhL0BCzGMF875LmAnkvvjq2Oxo4oQLek4teNDUmsM5
         /Xn0uYYGSjXhY8FrU+71ocuf07vQGBpKgaWFWC4l5SJ4oFR+QtBW+Ct+KOSWIDbJtr
         x2DZltEk620bzer4peQWn4bPK4IKr8niTflCN+TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 144/323] usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS
Date:   Thu, 20 May 2021 11:20:36 +0200
Message-Id: <20210520092125.040547510@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
 drivers/staging/typec/tcpci.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/typec/tcpci.c b/drivers/staging/typec/tcpci.c
index df72d8b01e73..39e2aee0b1a3 100644
--- a/drivers/staging/typec/tcpci.c
+++ b/drivers/staging/typec/tcpci.c
@@ -28,6 +28,15 @@
 
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
 	struct i2c_client *client;
@@ -149,19 +158,25 @@ static int tcpci_get_cc(struct tcpc_dev *tcpc,
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



