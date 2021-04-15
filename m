Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94AC360DB9
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhDOPFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233681AbhDOPBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A2F56141E;
        Thu, 15 Apr 2021 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498663;
        bh=Wr0mAqzuayHfsB4hc1QbyERS7Jdho/MmBrqo3CX1o08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AoBeYQ0vjEwt1UE0+55iw6t4XHRIyR7NfZipknmM7g62ybTfWnddLLclGj/Q7HIx
         DnQQ3jcrf1TfaQYQFWW+mpC+gjnPJqyKQ5uUGEyz677wZYwdr8KbDgYSR17b1Rif+G
         P5Sp+vOGgEUOfsrydRIl4EZG9FwtOR46QgVOhjTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.10 24/25] net: sfp: cope with SFPs that set both LOS normal and LOS inverted
Date:   Thu, 15 Apr 2021 16:48:18 +0200
Message-Id: <20210415144413.917036542@linuxfoundation.org>
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

commit 624407d2cf14ff58e53bf4b2af9595c4f21d606e upstream.

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
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1501,15 +1501,19 @@ static void sfp_sm_link_down(struct sfp
 
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
@@ -1519,18 +1523,22 @@ static void sfp_sm_link_check_los(struct
 
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


