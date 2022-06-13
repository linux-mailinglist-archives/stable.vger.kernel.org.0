Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C15492CE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355536AbiFMM5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355981AbiFMMzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D787BB4B5;
        Mon, 13 Jun 2022 04:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A8DBB80EA7;
        Mon, 13 Jun 2022 11:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A250C34114;
        Mon, 13 Jun 2022 11:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118934;
        bh=7h4rZyqwtDdmYLoZ2kB4nYcPAMuofr5Hp9IrMWAmCj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAhzHgMxWS18uaKf06VjKS7B1P7BuSbEM0GSfm9sgg77oe9QuUqEaVQoLZBJbPe8i
         4EtsK1thO2HdBuGsqsUOsoB4mjaKOpqxonHNFQY+LJlBs2d/lVV5ruD6kQtYTi3r1R
         xPf0Yx4J+XdcyizzaLwXeOcTSkt5cWBJFHX6eWGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/247] serial: 8250_fintek: Check SER_RS485_RTS_* only with RS485
Date:   Mon, 13 Jun 2022 12:09:15 +0200
Message-Id: <20220613094924.564104849@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit af0179270977508df6986b51242825d7edd59caf ]

SER_RS485_RTS_ON_SEND and SER_RS485_RTS_AFTER_SEND relate to behavior
within RS485 operation. The driver checks if they have the same value
which is not possible to realize with the hardware. The check is taken
regardless of SER_RS485_ENABLED flag and -EINVAL is returned when the
check fails, which creates problems.

This check makes it unnecessarily complicated to turn RS485 mode off as
simple zeroed serial_rs485 struct will trigger that equal values check.
In addition, the driver itself memsets its rs485 structure to zero when
RS485 is disabled but if userspace would try to make an TIOCSRS485
ioctl() call with the very same struct, it would end up failing with
-EINVAL which doesn't make much sense.

Resolve the problem by moving the check inside SER_RS485_ENABLED block.

Fixes: 7ecc77011c6f ("serial: 8250_fintek: Return -EINVAL on invalid configuration")
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/035c738-8ea5-8b17-b1d7-84a7b3aeaa51@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_fintek.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
index 251f0018ae8c..dba5950b8d0e 100644
--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -200,12 +200,12 @@ static int fintek_8250_rs485_config(struct uart_port *port,
 	if (!pdata)
 		return -EINVAL;
 
-	/* Hardware do not support same RTS level on send and receive */
-	if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
-			!(rs485->flags & SER_RS485_RTS_AFTER_SEND))
-		return -EINVAL;
 
 	if (rs485->flags & SER_RS485_ENABLED) {
+		/* Hardware do not support same RTS level on send and receive */
+		if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
+		    !(rs485->flags & SER_RS485_RTS_AFTER_SEND))
+			return -EINVAL;
 		memset(rs485->padding, 0, sizeof(rs485->padding));
 		config |= RS485_URA;
 	} else {
-- 
2.35.1



