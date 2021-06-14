Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41B53A620B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhFNKz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234248AbhFNKwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5778611CA;
        Mon, 14 Jun 2021 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667167;
        bh=peZiDraT53CMFShG/6Q9NfxmoddHpD2TdfJWZ6NmDbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmZRZeXbXyfyBtMfznx/ivI14cXtKEeURwcsIWi7VnMPAD7xlgOI2++psEGPPe4ab
         nBPBFbdpw+BWIiZeq0LaFH9ZPLLpJv7IRFPClnDXoKDiTsYo/PDPo7UySxN6yQuDwL
         mdm1r0RzVgD8VYXOMYXxYOq8ibX1temchgSvGPRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Drew Fustini <drew@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 5.4 51/84] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling
Date:   Mon, 14 Jun 2021 12:27:29 +0200
Message-Id: <20210614102648.103682556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
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
@@ -1871,9 +1871,8 @@ static void musb_pm_runtime_check_sessio
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


