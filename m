Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A486C0CDC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCTJM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjCTJMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C45D234DC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ECBE612CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709C6C433EF;
        Mon, 20 Mar 2023 09:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303549;
        bh=/xFBb1mqZQI/cPFaGkg7GVju/Wczy444tmEi139fFVA=;
        h=Subject:To:Cc:From:Date:From;
        b=Si1UjM+/6/EM2ttly83CuVFktvTiugURN3P4BC6flvntqSpJxjjAPbOSNZVpCDRx3
         FxRej486XBSe9T9KXVifvX2ghXb65KY+f2aFm8ALpLJTCrdYKwX8twktPUhNe2RKod
         2ryoJPF54Wsivr6j4Dx+9Zh0JksV/3CqZ5TYfdCQ=
Subject: FAILED: patch "[PATCH] serial: 8250_em: Fix UART port type" failed to apply to 4.19-stable tree
To:     biju.das.jz@bp.renesas.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:12:19 +0100
Message-ID: <1679303539169236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 32e293be736b853f168cd065d9cbc1b0c69f545d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679303539169236@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

32e293be736b ("serial: 8250_em: Fix UART port type")
2a1dbd259e63 ("serial: 8250_em: Switch to use platform_get_irq()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 32e293be736b853f168cd065d9cbc1b0c69f545d Mon Sep 17 00:00:00 2001
From: Biju Das <biju.das.jz@bp.renesas.com>
Date: Mon, 27 Feb 2023 11:41:46 +0000
Subject: [PATCH] serial: 8250_em: Fix UART port type

As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART
IP found on EMMA mobile SoC is Register-compatible with the
general-purpose 16750 UART chip. Fix UART port type as 16750 and
enable 64-bytes fifo support.

Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230227114152.22265-2-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index f8e99995eee9..d94c3811a8f7 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -106,8 +106,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 

