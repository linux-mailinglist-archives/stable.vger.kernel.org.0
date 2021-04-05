Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7EA353DCC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbhDEJCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237348AbhDEJCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F0E3613AE;
        Mon,  5 Apr 2021 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613308;
        bh=01X+ZlqpsSMrBWtoBB43At5ms1yK6F8ZDglb7QSOXhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dytfBcwkq8zrHsxESNq6Tr475qRQTOl7dbwEUit/KfmMZbjhvk4ktK1F8ncTB/NFa
         bLqFXyHFJZm9TnH8OJX4IL1SV1tjmb75mF3IfHKzl8dHrS/PCSfYgCJ4SOiF30uFTf
         ERWvgZsbPY/SzvSt/tk9O5jM+ZGsoa+6+T0gzvxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhushan Shah <bshah@kde.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 45/56] usb: musb: Fix suspend with devices connected for a64
Date:   Mon,  5 Apr 2021 10:54:16 +0200
Message-Id: <20210405085023.965967943@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 92af4fc6ec331228aca322ca37c8aea7b150a151 upstream.

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
 drivers/usb/musb/musb_core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1868,10 +1868,14 @@ static void musb_pm_runtime_check_sessio
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
+		/* fall through */
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,


