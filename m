Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CAF35CE7D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343932AbhDLQof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245263AbhDLQiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92FE861366;
        Mon, 12 Apr 2021 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244943;
        bh=4SwhDj3iDEdH7+mXs+MuzPV3kxZpat9gI12KS1vmveQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IY0fBeE71qC7GJ6cYb34uZPcpbSrtDc+zvwjv4VQlIruHLPBrge1RPNjMBpdyLEk8
         6ra9KKV84QVNFok3HeXmFVe8EdhKnR8RWWHGLsrvfddYaDpnJDVbBVYFyBRFg3miJr
         w2e3Xa+vo6M3e1Y8dydcMNNvagtTR+NjPwmW6ic4KcHrpQHNxer0arYWPIv5rZQvw2
         5Ybr0CbUEFlDEEVwTJRqHGoon4X8MlQ0FB/8Fu2ZbqeIss8CqlN6t69kUAkC93gQtY
         kmNhIi0ppTvB9mv45buYZjVxxOlik1QKi8dklgOhiDvADP5SynIoAl/VGwlN0xLN3z
         p+t02b5han+qw==
Received: by pali.im (Postfix)
        id 50FFC687; Mon, 12 Apr 2021 18:29:01 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: sfp: cope with SFPs that set both LOS normal and LOS inverted
Date:   Mon, 12 Apr 2021 18:28:33 +0200
Message-Id: <20210412162833.17496-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 624407d2cf14ff58e53bf4b2af9595c4f21d606e ]

The SFP MSA defines two option bits in byte 65 to indicate how the
Rx_LOS signal on SFP pin 8 behaves:

bit 2 - Loss of Signal implemented, signal inverted from standard
        definition in SFP MSA (often called "Signal Detect").
bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
        (often called "Rx_LOS").

Clearly, setting both bits results in a meaningless situation: it would
mean that LOS is implemented in both the normal sense (1 = signal loss)
and inverted sense (0 = signal loss).

Unfortunately, there are modules out there which set both bits, which
will be initially interpret as "inverted" sense, and then, if the LOS
signal changes state, we will toggle between LINK_UP and WAIT_LOS
states.

Change our LOS handling to give well defined behaviour: only interpret
these bits as meaningful if exactly one is set, otherwise treat it as
if LOS is not implemented.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Please apply this commit to all stable releases where was already
backported commit f0b4f847673299577c29b71d3f3acd3c313d81b7
("net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant")
as it depends on this commit. The Ubiquiti U-Fiber Instant SFP GPON
module has set both LOS_NORMAL and LOS_INVERTED bits so without this
commit it does not work. If I checked it correctly patch should go
into 5.10 and 5.11 releases.
---
 drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91d74c1a920a..55e6a2fc5bc6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1482,15 +1482,19 @@ static void sfp_sm_link_down(struct sfp *sfp)
 
 static void sfp_sm_link_check_los(struct sfp *sfp)
 {
-	unsigned int los = sfp->state & SFP_F_LOS;
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+	bool los = false;
 
 	/* If neither SFP_OPTIONS_LOS_INVERTED nor SFP_OPTIONS_LOS_NORMAL
-	 * are set, we assume that no LOS signal is available.
+	 * are set, we assume that no LOS signal is available. If both are
+	 * set, we assume LOS is not implemented (and is meaningless.)
 	 */
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED))
-		los ^= SFP_F_LOS;
-	else if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL)))
-		los = 0;
+	if (los_options == los_inverted)
+		los = !(sfp->state & SFP_F_LOS);
+	else if (los_options == los_normal)
+		los = !!(sfp->state & SFP_F_LOS);
 
 	if (los)
 		sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
@@ -1500,18 +1504,22 @@ static void sfp_sm_link_check_los(struct sfp *sfp)
 
 static bool sfp_los_event_active(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_LOW) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_HIGH);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_LOW) ||
+	       (los_options == los_normal && event == SFP_E_LOS_HIGH);
 }
 
 static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_HIGH) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_LOW);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_HIGH) ||
+	       (los_options == los_normal && event == SFP_E_LOS_LOW);
 }
 
 static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
-- 
2.20.1

