Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0428F1674A3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388458AbgBUIXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388457AbgBUIXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52BA224676;
        Fri, 21 Feb 2020 08:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273398;
        bh=vI7lV6bJSwFrfUSOqObJPGooulJ3EqcRpdA8ruW/WNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGkpiLLRN0eAB8QP55wOzXd92M+4LN33VDOoVV0QGEcqGa2YkkmmL909iYplK2Pho
         QoMxKIUMoIOO4d+3gbvz7iwdtshZ9qr5DBLu5Niph/7KRZDuKicnq9qeB31YHs2hL5
         WKAfy3HfHpw4jFhOWUxbuDK69YPYtLY/Z5yuyYdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Tony Lindgren <tony@atomide.com>, Bin Liu <b-liu@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/191] usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue
Date:   Fri, 21 Feb 2020 08:41:42 +0100
Message-Id: <20200221072306.356901772@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 91b6dec32e5c25fbdbb564d1e5af23764ec17ef1 ]

We currently have musb_set_vbus() called from two different paths. Mostly
it gets called from the USB PHY via omap_musb_set_mailbox(), but in some
cases it can get also called from musb_stage0_irq() rather via .set_vbus:

(musb_set_host [musb_hdrc])
(omap2430_musb_set_vbus [omap2430])
(musb_stage0_irq [musb_hdrc])
(musb_interrupt [musb_hdrc])
(omap2430_musb_interrupt [omap2430])

This is racy and will not work with introducing generic helper functions
for musb_set_host() and musb_set_peripheral(). We want to get rid of the
busy loops in favor of usleep_range().

Let's just get rid of .set_vbus for omap2430 glue layer and let the PHY
code handle VBUS with musb_set_vbus(). Note that in the follow-up patch
we can completely remove omap2430_musb_set_vbus(), but let's do it in a
separate patch as this change may actually turn out to be needed as a
fix.

Reported-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200115132547.364-5-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/omap2430.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index b1dd81fb5f55e..24e622c056383 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -361,8 +361,6 @@ static const struct musb_platform_ops omap2430_ops = {
 	.init		= omap2430_musb_init,
 	.exit		= omap2430_musb_exit,
 
-	.set_vbus	= omap2430_musb_set_vbus,
-
 	.enable		= omap2430_musb_enable,
 	.disable	= omap2430_musb_disable,
 
-- 
2.20.1



