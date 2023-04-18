Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE36E61AF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDRM0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjDRM0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14CB46B2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A5A6315B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA942C433A7;
        Tue, 18 Apr 2023 12:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820757;
        bh=RCIYvKF0ZjpsGOmr6O6TbZEw3m/J6vkgw6TYrAVSfXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuIksjS41GG2EViVG0tO20zMUGg4lQN6oCEN4xASh8+XpvahGV2GyYTRuLvpNMzog
         bm+HGi5ZviikweCwRNa1D2/vwZGFEb65HyGPhJuuagOmcSjW1gZUhVu7BVJeNp1eEX
         fWu8MPsGQIi4Mz4kIoU5H8fgI3uh+bCGJxagyz0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 4.19 20/57] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date:   Tue, 18 Apr 2023 14:21:20 +0200
Message-Id: <20230418120259.456305991@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit f92ed0cd9328aed918ebb0ebb64d259eccbcc6e7 upstream.

SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
IPs on the SH platform. Currently, it does regshift and configuring Rx
wrongly. Drop adding regshift for RZ/G2L alike SoCs.

Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value for SCI ports")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230321114753.75038-3-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2980,7 +2980,7 @@ static int sci_init_single(struct platfo
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else


