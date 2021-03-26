Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903EF34A907
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCZNwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhCZNv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E1061A18;
        Fri, 26 Mar 2021 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616766717;
        bh=hEXdd1jr4xxA3hKKWMwjyQgtpuOnoZVFcADUWwixOfQ=;
        h=Subject:To:From:Date:From;
        b=ShUIoD/3cIirH993Phz+Ha9dEMq2eRDpS/IooxPBeYQll9JJ8zTc3mghKWMZlH9dr
         2v1WR5mizyhoN6eA3lmiJDn918LUIQxv+VRPeo8u9XIjuKz8P2Prwe8P6jsiYQTIbn
         KSCYT+2m52TbG7rukgGM00EjUMoU3QJpP1Y2heGA=
Subject: patch "usb: musb: Fix suspend with devices connected for a64" added to usb-linus
To:     tony@atomide.com, bshah@kde.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 14:51:44 +0100
Message-ID: <161676670482243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: musb: Fix suspend with devices connected for a64

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 92af4fc6ec331228aca322ca37c8aea7b150a151 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 24 Mar 2021 09:11:41 +0200
Subject: usb: musb: Fix suspend with devices connected for a64

Pinephone running on Allwinner A64 fails to suspend with USB devices
connected as reported by Bhushan Shah <bshah@kde.org>. Reverting
commit 5fbf7a253470 ("usb: musb: fix idling for suspend after
disconnect interrupt") fixes the issue.

Let's add suspend checks also for suspend after disconnect interrupt
quirk handling like we already do elsewhere.

Fixes: 5fbf7a253470 ("usb: musb: fix idling for suspend after disconnect interrupt")
Reported-by: Bhushan Shah <bshah@kde.org>
Tested-by: Bhushan Shah <bshah@kde.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210324071142.42264-1-tony@atomide.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 1cd87729ba60..fc0457db62e1 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2004,10 +2004,14 @@ static void musb_pm_runtime_check_session(struct musb *musb)
 		MUSB_DEVCTL_HR;
 	switch (devctl & ~s) {
 	case MUSB_QUIRK_B_DISCONNECT_99:
-		musb_dbg(musb, "Poll devctl in case of suspend after disconnect\n");
-		schedule_delayed_work(&musb->irq_work,
-				      msecs_to_jiffies(1000));
-		break;
+		if (musb->quirk_retries && !musb->flush_irq_work) {
+			musb_dbg(musb, "Poll devctl in case of suspend after disconnect\n");
+			schedule_delayed_work(&musb->irq_work,
+					      msecs_to_jiffies(1000));
+			musb->quirk_retries--;
+			break;
+		}
+		fallthrough;
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,
-- 
2.31.0


