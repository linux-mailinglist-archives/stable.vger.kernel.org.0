Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D454929D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355245AbiFMM42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358206AbiFMMzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA0D3586E;
        Mon, 13 Jun 2022 04:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44C7FB80D31;
        Mon, 13 Jun 2022 11:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ACDC34114;
        Mon, 13 Jun 2022 11:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118879;
        bh=eLctX8eHUcChWaLRtJGU7lck7K7zOeKgJQ65eAtaEQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcVkya3cVD4a/tNQQo/Plm41VFNuOfmuxRNwWoYwZyGREpB0+t4UEkhyl5EQP8cIR
         pXeiLYI7qkm4GxVoMLrCQKNZWzdAMusTZeorvyeR2OU+MuQK01hv3XJzKSG0Gcf+NB
         DqAtV5tEhklpqYCIJn61UA/wqJ2TeC01j2W9lYBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@st.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/247] serial: stm32-usart: Correct CSIZE, bits, and parity
Date:   Mon, 13 Jun 2022 12:09:23 +0200
Message-Id: <20220613094924.807444363@linuxfoundation.org>
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

[ Upstream commit 1deeda8d2877c18bc2b9eeee10dd6d2628852848 ]

Add CSIZE sanitization for unsupported CSIZE configurations. In
addition, if parity is asked for but CSx was unsupported, the sensible
result is CS8+parity which requires setting USART_CR1_M0 like with 9
bits.

Incorrect CSIZE results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Fixes: c8a9d043947b (serial: stm32: fix word length configuration)
Cc: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-9-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 810a1b0b6520..10e9f983de62 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -807,13 +807,22 @@ static void stm32_usart_set_termios(struct uart_port *port,
 	 * CS8 or (CS7 + parity), 8 bits word aka [M1:M0] = 0b00
 	 * M0 and M1 already cleared by cr1 initialization.
 	 */
-	if (bits == 9)
+	if (bits == 9) {
 		cr1 |= USART_CR1_M0;
-	else if ((bits == 7) && cfg->has_7bits_data)
+	} else if ((bits == 7) && cfg->has_7bits_data) {
 		cr1 |= USART_CR1_M1;
-	else if (bits != 8)
+	} else if (bits != 8) {
 		dev_dbg(port->dev, "Unsupported data bits config: %u bits\n"
 			, bits);
+		cflag &= ~CSIZE;
+		cflag |= CS8;
+		termios->c_cflag = cflag;
+		bits = 8;
+		if (cflag & PARENB) {
+			bits++;
+			cr1 |= USART_CR1_M0;
+		}
+	}
 
 	if (ofs->rtor != UNDEF_REG && (stm32_port->rx_ch ||
 				       (stm32_port->fifoen &&
-- 
2.35.1



