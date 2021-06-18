Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7753AC3E5
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhFRGcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFRGcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:32:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D0D61209;
        Fri, 18 Jun 2021 06:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997840;
        bh=6L5fRT3g6YpkdehVTR5QmM2I2qR3vWvg7flStSddsVE=;
        h=Subject:To:From:Date:From;
        b=VNWtwvLrHFbJyZbw3EmBsROii+pgdiJePVdOrYZrE6PVSEcb30WfR8RDOhG9rebr/
         rlsfDrogV7nWieGO1w1L2ofwJAO3w7ebyv0YwFYTNmzcCAEb7HDASbVLiJ7CU8gESf
         nw/7mzC7WhHhDr5qCld4w5VkcX/WLwXT3VXUd0Xo=
Subject: patch "usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON state" added to usb-next
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:30:22 +0200
Message-ID: <162399782218617@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


