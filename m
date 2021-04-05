Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79E353D49
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhDEI7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhDEI73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA0B613B5;
        Mon,  5 Apr 2021 08:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613162;
        bh=gVj4Mj9DlSzrMbe5wvgdaCs0hGEtc008BQXV4tO4Yg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1BaSO2OMPQijwkr0gs+yCAZAg2fSpGz0gVpOGbZifWkuDNdW6KC3Uq2C3gFBkawB
         ogMJq0oHqlXFwn5XKCqmR4Q28zKogzUR6DpLiTBf82vy/2moy99q3PRW2Xb3VnofpY
         qAS3iXeDmup0h/2ltBjvc4sZFzgkt0yld+tRXlX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhushan Shah <bshah@kde.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 43/52] usb: musb: Fix suspend with devices connected for a64
Date:   Mon,  5 Apr 2021 10:54:09 +0200
Message-Id: <20210405085023.377716208@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -1864,10 +1864,14 @@ static void musb_pm_runtime_check_sessio
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


