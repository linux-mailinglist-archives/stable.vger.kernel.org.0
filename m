Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2C3A6417
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhFNLUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235046AbhFNLSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F3661460;
        Mon, 14 Jun 2021 10:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667841;
        bh=SFqTcPLp68F4X8oUQPz8AjYKwnZ3gBqyHspDLVrGtfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2R03VShujrftFbrQBSfyTk9Q3Qj7RINxh8YaJyP4Mvo9HkjCj9eOqtmsKmlp65fd
         MnXQ44QvPU1I4WwH7CaoxAQ62V7+voo/omdVHaL6MguJBJWW+5e4mxVO1/dAvInF+k
         AJzXsPGysbubsnnMpqRkXzZdzu3VRC/qR3vOPiRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Drew Fustini <drew@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 5.12 094/173] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling
Date:   Mon, 14 Jun 2021 12:27:06 +0200
Message-Id: <20210614102701.297901728@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>

commit b65ba0c362be665192381cc59e3ac3ef6f0dd1e1 upstream.

In commit 92af4fc6ec33 ("usb: musb: Fix suspend with devices
connected for a64"), the logic to support the
MUSB_QUIRK_B_DISCONNECT_99 quirk was modified to only conditionally
schedule the musb->irq_work delayed work.

This commit badly breaks ECM Gadget on AM335X. Indeed, with this
commit, one can observe massive packet loss:

$ ping 192.168.0.100
...
15 packets transmitted, 3 received, 80% packet loss, time 14316ms

Reverting this commit brings back a properly functioning ECM
Gadget. An analysis of the commit seems to indicate that a mistake was
made: the previous code was not falling through into the
MUSB_QUIRK_B_INVALID_VBUS_91, but now it is, unless the condition is
taken.

Changing the logic to be as it was before the problematic commit *and*
only conditionally scheduling musb->irq_work resolves the regression:

$ ping 192.168.0.100
...
64 packets transmitted, 64 received, 0% packet loss, time 64475ms

Fixes: 92af4fc6ec33 ("usb: musb: Fix suspend with devices connected for a64")
Cc: stable@vger.kernel.org
Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Drew Fustini <drew@beagleboard.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Link: https://lore.kernel.org/r/20210528140446.278076-1-thomas.petazzoni@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2009,9 +2009,8 @@ static void musb_pm_runtime_check_sessio
 			schedule_delayed_work(&musb->irq_work,
 					      msecs_to_jiffies(1000));
 			musb->quirk_retries--;
-			break;
 		}
-		fallthrough;
+		break;
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,


