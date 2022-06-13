Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3445E549457
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382501AbiFMORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383564AbiFMOQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:16:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4799EB7D;
        Mon, 13 Jun 2022 04:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B81D613F9;
        Mon, 13 Jun 2022 11:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697C4C34114;
        Mon, 13 Jun 2022 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120606;
        bh=TGB8fvzfl3YhMocGqLbDYunFAdllXXLShxgvHAoCEIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmyKRuO26tFJjZB5ED4Haknjuv1NkE0yCMZ873n8xYLruFOhj73rq0SUJPi3VlWwo
         aM2r7lNiwu8tjPC1QPlpV51h6Vz+YssSANl0okWxrn/eIRaxr3V2jkxLk5pRpyYIPV
         ChUQ7V2b49rLvGjH31kxNDRZA7KD+95CAGBxY+Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 060/298] serial: digicolor-usart: Dont allow CS5-6
Date:   Mon, 13 Jun 2022 12:09:14 +0200
Message-Id: <20220613094926.769236669@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

[ Upstream commit fd63031b8c0763addcecdefe0e0c59d49646204e ]

Only CS7 and CS8 seem supported but CSIZE is not sanitized to CS8 in
the default: block.

Set CSIZE correctly so that userspace knows the effective value.
Incorrect CSIZE also results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: 5930cb3511df (serial: driver for Conexant Digicolor USART)
Acked-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/digicolor-usart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index c7f81aa1ce91..5fea9bf86e85 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -309,6 +309,8 @@ static void digicolor_uart_set_termios(struct uart_port *port,
 	case CS8:
 	default:
 		config |= UA_CONFIG_CHAR_LEN;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
-- 
2.35.1



