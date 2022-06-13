Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC854549831
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353859AbiFMLcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354947AbiFMLaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199D0403FD;
        Mon, 13 Jun 2022 03:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 947B6B80D3C;
        Mon, 13 Jun 2022 10:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1666C34114;
        Mon, 13 Jun 2022 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117165;
        bh=Ok3La8mRQV7bu6LFgpuG/TAdbgySw0P+nNilnEqF8j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjNbEgBdXRXx8sTcq69oEeKIPrHugmNb3qdAoYRV6nVJjKpbsoa00ZJMomm+ijZ0O
         vSVUeEHsGGuAt4iLbDRymD/s1IMRoIekBpV/kfqZ26tssVpU/jvP5wJCJ9Wv8F2ho3
         yrde7wy2WET7Slm6zUBQMlmXDtZSGx9fi84B0ZYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/411] serial: rda-uart: Dont allow CS5-6
Date:   Mon, 13 Jun 2022 12:09:42 +0200
Message-Id: <20220613094938.014578255@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 098333a9c7d12bb3ce44c82f08b4d810c44d31b0 ]

Only CS7 and CS8 are supported but CSIZE is not sanitized after
fallthrough from CS5 or CS6 to CS7.

Set CSIZE correctly so that userspace knows the effective value.
Incorrect CSIZE also results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: c10b13325ced (tty: serial: Add RDA8810PL UART driver)
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/rda-uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/rda-uart.c b/drivers/tty/serial/rda-uart.c
index ff9a27d48bca..877d86ff6819 100644
--- a/drivers/tty/serial/rda-uart.c
+++ b/drivers/tty/serial/rda-uart.c
@@ -262,6 +262,8 @@ static void rda_uart_set_termios(struct uart_port *port,
 		/* Fall through */
 	case CS7:
 		ctrl &= ~RDA_UART_DBITS_8;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS7;
 		break;
 	default:
 		ctrl |= RDA_UART_DBITS_8;
-- 
2.35.1



