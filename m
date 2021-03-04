Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B51C32CD57
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhCDHKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbhCDHKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 02:10:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E4C06175F
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 23:09:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 127so29638220ybc.19
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 23:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=6SYKOly+jweugIylMFB95EbkQpY3TPkXyF08BjG+EYk=;
        b=pir1oZAyUls7R39beNX8rUtSrLX+skRk3aAi9rhfDi6PNKwuxwKaRzM0Ya1ou874d+
         IyYZK/KjNBF0Hnqi+7bLNQRLxdcBm8x9+sJ0tSrz+HNiBzSRrUrWYWufOi6eGzpqN7Jl
         d61BDFGS84Cbr8fIHfU9IxEkb8EUYDY1PXna0XKvZXmmauWLVeJjcxXr7xqT8/T7C7vK
         TFQf9LzKiVsBxALCf1XZcuAWWLzpATs1YEU0VgFkmA408cuHQMAb3yOOPTo9vWWSzpUs
         8nxpwlmRGU+NNMnJbWz4fdykIPQjo5yOCdz+uCEGrxfALeSO7CpWEmA2S71q2pqDi1hq
         d96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=6SYKOly+jweugIylMFB95EbkQpY3TPkXyF08BjG+EYk=;
        b=hNTfw8cSb9W3z8CONURuzGV6dWiAayJLgtkN4+0Amsvli3+0LxohrJgqzzI9Fbfbs9
         iu3/GMn6wOeaLYk5kdRL4K5pJXVO8xdNMfegAv80g9qOzjdyQ9JPW9ZXp5XBmGcVJB5n
         xIBvtvXe4k0BbqWSDVCMY0k1lErYXOb+0vOrv155Q9MJBUK016Eypr2sFCEsaVT4Y1x+
         K9vYwb/CvfQbGVXRSnXpJZ+j14K4lWVkAdqLE+6gZEjGrOeXo7zV3kscVe9HzVvHn+I8
         GiuVGjy8V++TmYTD5lV41w7uViRHGCKZeUdGjxv2OkqDwPbMoXWXARv1sKUE7z8qeH3I
         yvkg==
X-Gm-Message-State: AOAM530Zb4UcMTXn4lPY5kc8w0q5CZ9fIwy1gU808mqxbXkSmo3WIFIw
        GXLhjsk88dJf7XrdWBT8W7eucAnr5Vc=
X-Google-Smtp-Source: ABdhPJwz9/qlY/4sHrDsgAhu1Tjex6y12rlx/rEieWUpOFcszT7Bqn0mNl1TPE0F5Xsf6YGYIDDa7h2Saps=
Sender: "badhri via sendgmr" <badhri@badhri.mtv.corp.google.com>
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:543f:67ae:599c:e076])
 (user=badhri job=sendgmr) by 2002:a25:c006:: with SMTP id c6mr4556819ybf.353.1614841775027;
 Wed, 03 Mar 2021 23:09:35 -0800 (PST)
Date:   Wed,  3 Mar 2021 23:09:31 -0800
Message-Id: <20210304070931.1947316-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v1] usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While interpreting CC_STATUS, ROLE_CONTROL has to be read to make
sure that CC1/CC2 is not forced presenting Rp/Rd.

From the TCPCI spec:

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

Fixes: 74e656d6b0551 ("staging: typec: Type-C Port Controller
Interface driver (tcpci)")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpci.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index a27deb0b5f03..027afd7dfdce 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -24,6 +24,15 @@
 #define	AUTO_DISCHARGE_PD_HEADROOM_MV		850
 #define	AUTO_DISCHARGE_PPS_HEADROOM_MV		1250
 
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
 
@@ -178,19 +187,25 @@ static int tcpci_get_cc(struct tcpc_dev *tcpc,
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
2.30.1.766.gb4fecdf3b7-goog

