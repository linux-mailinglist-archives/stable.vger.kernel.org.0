Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B83AB50D
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhFQNmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 09:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232588AbhFQNmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 09:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7079613CE;
        Thu, 17 Jun 2021 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623937197;
        bh=45ASd4dvz9pPqGJslvtQ/yxteLxlx+nmgm7zgWJnx5w=;
        h=Subject:To:From:Date:From;
        b=A0CFH92JZxDvLLDdsbKcgGprQzvdyN5mybVGRpRErnuOGeX9zcvsjkBlb0Bf7vBWG
         EFvVo1xWqNwG3oA/a0BTep+nV090l7TWIpPr1h7i2QUfGwinKAbBOUta2kM5Q3pcrZ
         aoWdyNlXl1eSXaAo1R37mdgaLa8uEcIUjlm6Ji0E=
Subject: patch "usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON state" added to usb-testing
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 15:39:44 +0200
Message-ID: <162393718413810@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON state

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From fed09e0bf9f0622a54f3963f959d914fa817f8a6 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Wed, 16 Jun 2021 01:32:06 +0800
Subject: usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON state

In PR_SWAP_SNK_SRC_SOURCE_ON state, Vsafe0v is expected as well so do
nothing here to avoid state machine going into SNK_UNATTACHED.

Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210615173206.1646477-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 197556038ba4..e11e9227107d 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5212,6 +5212,7 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 		}
 		break;
 	case PR_SWAP_SNK_SRC_SINK_OFF:
+	case PR_SWAP_SNK_SRC_SOURCE_ON:
 		/* Do nothing, vsafe0v is expected during transition */
 		break;
 	default:
-- 
2.32.0


