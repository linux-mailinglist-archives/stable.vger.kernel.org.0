Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA0594C5B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiHPAm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349280AbiHPAlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDD318EC2B;
        Mon, 15 Aug 2022 13:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7739560F60;
        Mon, 15 Aug 2022 20:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E8EC433C1;
        Mon, 15 Aug 2022 20:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595954;
        bh=Et3J7TTyEf0zhFy7gHsoT3NCUvxMZ4Fzd+9iFqXT2GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWOJVKHDh0qhMe5LV56VwbvxnqS56OEqfatCOpIfpgmeXiGU/ueVW4XZir4wV7dvm
         mry8TpRjU0lqeBXamGiKyyUX+3PiP2lo3TqL7XyQUL9daRMi2O6CqeeG/iTIpmEHJI
         lrb6gdHycXCmRi78rbU2wLqqw/We8ziOPD9sHSV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0900/1157] serial: 8250: Get preserved flags using serial_lsr_in()
Date:   Mon, 15 Aug 2022 20:04:16 +0200
Message-Id: <20220815180515.457945267@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 6a4241e8f9b17aa17f55842d6478f280c22d2b44 ]

serial8250_handle_irq() assumes it's the first to read LSR register.
However, there are 8250 drivers which perform LSR read in their own irq
handler prior to calling serial8250_handle_irq(). As not all flags are
preserved across LSR reads, use serial_lsr_in() helper to get all the
preserved flags.

This commit might fix other commits too besides the ones for DW UART
mentioned below. It's just not clear to me which of the other devices
clear some of the LSR flags on read. AFAIK, nobody has complained about
this problem (either against DW or other devices) so it might not have
that bad impact in the end.

Fixes: 424d79183af0 ("serial: 8250_dw: Avoid "too much work" from bogus rx timeout interrupt")
Fixes: aa63d786cea2 ("serial: 8250: dw: Add support for DMA flow controlling devices")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220608095431.18376-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index c9d8c0de56e5..2b86c55ed374 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1922,7 +1922,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	spin_lock_irqsave(&port->lock, flags);
 
-	status = serial_port_in(port, UART_LSR);
+	status = serial_lsr_in(up);
 
 	/*
 	 * If port is stopped and there are no error conditions in the
-- 
2.35.1



