Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90A96C16C4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjCTPI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjCTPIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334A32E835
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D4DB6154D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D7CC433EF;
        Mon, 20 Mar 2023 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324585;
        bh=h3y3HH01KgcJq02AOFdV2sZ5v+gM4bqe9amZ6i9IiDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkr1UYOdwxWpekUkRPfa1I6o+7JF5QbXP/pFLquI9oFkGBCwIbeZQVNoCrEVVlp64
         HAyqg/OvUZ0/i6VKlliZFE3ZLCADQWBECxQh2OerSxYt1EyMWLcaX8OcZukL2EecLQ
         yLxpvNPd/UVVVjGeIR6YAQ8qeeJnTQ9EkxUYdAaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.4 56/60] serial: 8250_em: Fix UART port type
Date:   Mon, 20 Mar 2023 15:55:05 +0100
Message-Id: <20230320145433.255720925@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 32e293be736b853f168cd065d9cbc1b0c69f545d upstream.

As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART
IP found on EMMA mobile SoC is Register-compatible with the
general-purpose 16750 UART chip. Fix UART port type as 16750 and
enable 64-bytes fifo support.

Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230227114152.22265-2-biju.das.jz@bp.renesas.com
[biju: manually fixed the conflicts]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_em.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -102,8 +102,8 @@ static int serial8250_em_probe(struct pl
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq->start;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 


