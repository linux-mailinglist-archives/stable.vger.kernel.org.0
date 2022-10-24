Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB860A8D9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiJXNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbiJXNKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3999A2337;
        Mon, 24 Oct 2022 05:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92B41612E4;
        Mon, 24 Oct 2022 12:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AA3C433D6;
        Mon, 24 Oct 2022 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613503;
        bh=QI9wxZDgrBqPGWPZkZgZkNGHm56xUlzdIwnv5LHH7ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=butk5ILDT73S+ubSGXEY/U4v2Km0wyb2LRzZWswbFF4rlOKknXdtLgeA3H1c6ynba
         zULLkNdxD1VoVO5nXpVWcqHNpe2rNCX7GjU7iu96A10p2/AwN3a+rrC6Z2M2Ql8h4+
         hmOBCarFdkNSHBy3pjZoHqxet2H4By2iBVmyHidI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/255] serial: 8250: Fix restoring termios speed after suspend
Date:   Mon, 24 Oct 2022 13:31:04 +0200
Message-Id: <20221024113007.770480129@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 379a33786d489ab81885ff0b3935cfeb36137fea ]

Since commit edc6afc54968 ("tty: switch to ktermios and new framework")
termios speed is no longer stored only in c_cflag member but also in new
additional c_ispeed and c_ospeed members. If BOTHER flag is set in c_cflag
then termios speed is stored only in these new members.

Since commit 027b57170bf8 ("serial: core: Fix initializing and restoring
termios speed") termios speed is available also in struct console.

So properly restore also c_ispeed and c_ospeed members after suspend to fix
restoring termios speed which is not represented by Bnnn constant.

Fixes: 4516d50aabed ("serial: 8250: Use canary to restart console after suspend")
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220924104324.4035-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index f8819f72304a..c1551319684f 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -3180,8 +3180,13 @@ static void serial8250_console_restore(struct uart_8250_port *up)
 	unsigned int baud, quot, frac = 0;
 
 	termios.c_cflag = port->cons->cflag;
-	if (port->state->port.tty && termios.c_cflag == 0)
+	termios.c_ispeed = port->cons->ispeed;
+	termios.c_ospeed = port->cons->ospeed;
+	if (port->state->port.tty && termios.c_cflag == 0) {
 		termios.c_cflag = port->state->port.tty->termios.c_cflag;
+		termios.c_ispeed = port->state->port.tty->termios.c_ispeed;
+		termios.c_ospeed = port->state->port.tty->termios.c_ospeed;
+	}
 
 	baud = serial8250_get_baud_rate(port, &termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
-- 
2.35.1



