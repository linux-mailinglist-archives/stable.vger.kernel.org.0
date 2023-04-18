Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565336E62AB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDRMef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjDRMee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A53118C2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285CF6324F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C91EC433D2;
        Tue, 18 Apr 2023 12:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821256;
        bh=H2HtnFPutSbT1AV3LWQ61DLo5X4z/uqzAVFuZdHElBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXRdrKiGJhJeDLMbI5tXu04YVlSRba1lk1RughCxO5DK7ZCq7aQjLcZZx3pmV71Mc
         eIYcn6Apmjht+vRu+Yw5U0dJ5KE1oXCm+PD4YcRqewuROK+ji2NpA+WxFZdGoUcAbH
         /yADlnvYAU03nXmIeqt6prEt2VINJ5RuOe2cOL7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.10 028/124] tty: serial: sh-sci: Fix transmit end interrupt handler
Date:   Tue, 18 Apr 2023 14:20:47 +0200
Message-Id: <20230418120310.762711076@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit b43a18647f03c87e77d50d6fe74904b61b96323e upstream.

The fourth interrupt on SCI port is transmit end interrupt compared to
the break interrupt on other port types. So, shuffle the interrupts to fix
the transmit end interrupt handler.

Fixes: e1d0be616186 ("sh-sci: Add h8300 SCI")
Cc: stable <stable@kernel.org>
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230317150403.154094-1-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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
@@ -2923,6 +2924,13 @@ static int sci_init_single(struct platfo
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


