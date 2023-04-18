Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880FE6E62AC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjDRMei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjDRMeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86A46B9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C000C611B1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55B1C433EF;
        Tue, 18 Apr 2023 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821259;
        bh=7RKnwdtlR++x0iENO0akokjs7INYDOJoCLWy0tLtDMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la/D2LL14cO9teVNiKq+70hn+AUK8j1ZCcZKDi9n+rzbjQ4cIFL5pMjScvehvTZ2J
         vfu+HQDNMAA9p5RjZ8wVmc0fFKkqP1ruNhLEgi/L5mTUp8bmBfahmlv5HPKO1TStu7
         80EK/Ildef4q7wvl9uE9C8r+F5HH6H9KsyWY8C/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 5.10 029/124] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date:   Tue, 18 Apr 2023 14:20:48 +0200
Message-Id: <20230418120310.813908846@linuxfoundation.org>
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
@@ -2996,7 +2996,7 @@ static int sci_init_single(struct platfo
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else


