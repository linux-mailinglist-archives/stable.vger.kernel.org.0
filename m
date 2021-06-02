Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3130398D9A
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 17:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhFBPB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 11:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhFBPB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 11:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D28560C3F;
        Wed,  2 Jun 2021 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622645983;
        bh=p90PEnh+WasKVzPsLex+vGO3sT+XX6uHCSlFs0kkA50=;
        h=Subject:To:From:Date:From;
        b=Vi2CpWwyBsvVJHCiXHTT1gE2epwwWLM9g9gyChNIkAWGjiFrxgupNiZTaFALAD8A5
         hZ9kWxDry9gG28qlznKOZtpiqSZIHPzDfA3mN29dyGNDYb3+LCLHx8kWyv916asIBQ
         eVrTs191Gs/OUeVYG/wi3aJ1NlKBPXEimuwi/Cqk=
Subject: patch "usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 02 Jun 2021 16:59:40 +0200
Message-ID: <1622645980164101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6490fa565534fa83593278267785a694fd378a2b Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Fri, 28 May 2021 16:16:13 +0800
Subject: usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms

Current timer PD_T_SINK_WAIT_CAP is set to 240ms which will violate the
SinkWaitCapTimer (tTypeCSinkWaitCap 310 - 620 ms) defined in the PD
Spec if the port is faster enough when running the state machine. Set it
to the lower bound 310ms to ensure the timeout is in Spec.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210528081613.730661-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb/pd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/pd.h b/include/linux/usb/pd.h
index bf00259493e0..96b7ff66f074 100644
--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -460,7 +460,7 @@ static inline unsigned int rdo_max_power(u32 rdo)
 #define PD_T_RECEIVER_RESPONSE	15	/* 15ms max */
 #define PD_T_SOURCE_ACTIVITY	45
 #define PD_T_SINK_ACTIVITY	135
-#define PD_T_SINK_WAIT_CAP	240
+#define PD_T_SINK_WAIT_CAP	310	/* 310 - 620 ms */
 #define PD_T_PS_TRANSITION	500
 #define PD_T_SRC_TRANSITION	35
 #define PD_T_DRP_SNK		40
-- 
2.31.1


