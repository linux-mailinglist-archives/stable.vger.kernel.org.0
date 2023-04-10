Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156056DCA2E
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 19:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjDJRr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 13:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjDJRrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 13:47:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7403E1710
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 10:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F75A612BB
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 17:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F265FC433D2;
        Mon, 10 Apr 2023 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681148870;
        bh=2QbSZq0YMuerZZRhR4e7zT6kPDayRr5PUUS4lXi8sY4=;
        h=Subject:To:Cc:From:Date:From;
        b=CGTc1PsJS8emfFWUWf4AP21Jmsdh4MLMybWNy+wHy+KsJIKRfJ+VcA4ihOXeTJkjC
         YyiE0GTig8ejBjVwuGsUncrsjU3Sr5m/V3AXFZGLZva8ynI1kwBQn1DDrnEBRIcUrU
         MPLTD/ObzABgHPsk2ERpIBZyfh7CQn+CKP7s7P7c=
Subject: FAILED: patch "[PATCH] tty: serial: sh-sci: Fix transmit end interrupt handler" failed to apply to 4.14-stable tree
To:     biju.das.jz@bp.renesas.com, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 19:47:47 +0200
Message-ID: <2023041046-synthetic-urgent-3126@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x b43a18647f03c87e77d50d6fe74904b61b96323e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041046-synthetic-urgent-3126@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

b43a18647f03 ("tty: serial: sh-sci: Fix transmit end interrupt handler")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b43a18647f03c87e77d50d6fe74904b61b96323e Mon Sep 17 00:00:00 2001
From: Biju Das <biju.das.jz@bp.renesas.com>
Date: Fri, 17 Mar 2023 15:04:03 +0000
Subject: [PATCH] tty: serial: sh-sci: Fix transmit end interrupt handler

The fourth interrupt on SCI port is transmit end interrupt compared to
the break interrupt on other port types. So, shuffle the interrupts to fix
the transmit end interrupt handler.

Fixes: e1d0be616186 ("sh-sci: Add h8300 SCI")
Cc: stable <stable@kernel.org>
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230317150403.154094-1-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 7bd080720929..c07663fe80bf 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/ktime.h>
 #include <linux/major.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/of.h>
@@ -2864,6 +2865,13 @@ static int sci_init_single(struct platform_device *dev,
 			sci_port->irqs[i] = platform_get_irq(dev, i);
 	}
 
+	/*
+	 * The fourth interrupt on SCI port is transmit end interrupt, so
+	 * shuffle the interrupts.
+	 */
+	if (p->type == PORT_SCI)
+		swap(sci_port->irqs[SCIx_BRI_IRQ], sci_port->irqs[SCIx_TEI_IRQ]);
+
 	/* The SCI generates several interrupts. They can be muxed together or
 	 * connected to different interrupt lines. In the muxed case only one
 	 * interrupt resource is specified as there is only one interrupt ID.

