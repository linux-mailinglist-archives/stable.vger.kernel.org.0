Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44C2E1615
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLWC5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgLWCUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D06D22202;
        Wed, 23 Dec 2020 02:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690002;
        bh=O4qMQroSwZ+/X2Ecyn7WFV296lPaetdg1kz/ioPO50Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPLBh5bVa1rW67lWELGYteOWxbtO7CfANo7XsjxBJSMIQrWiGELFPi1dQvuzuI84s
         sso/PXmqgy7YDiN5O8NL6/NEsFHned2pvwjEFHSLGI+ZXLCxrj9B5CfIQvIC4jebj/
         9R79ydcnF9wUk2w5xrRSIhXie1alIV9eh6TGOs/hPgfKMaE7gR3OA4j1FimVVCSGlt
         ZFToUahRrr1Wh5phaP7WnpDXaaLdHOFoiMSJ5eT2yx1Hwes1MuRSVPnFZA8bI8pA4z
         r6arHjgdY0G9m9XfZbqxsJ1l+8avUoCrY9dfqcjxfEiTrw6ZtJvtpcQmQLhLGDMX91
         w/2fO9wBCMsEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mingrui Ren <jiladahe1997@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 084/130] tty/serial/imx: Enable TXEN bit in imx_poll_init().
Date:   Tue, 22 Dec 2020 21:17:27 -0500
Message-Id: <20201223021813.2791612-84-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingrui Ren <jiladahe1997@gmail.com>

[ Upstream commit aef1b6a27970607721a618a0b990716ca8dbbf97 ]

As described in Documentation, poll_init() is called by kgdb to initialize
hardware which supports both poll_put_char() and poll_get_char().

It's necessary to enable TXEN bit, otherwise, it will cause hardware fault
and kernel panic when calling imx_poll_put_char().

Generally, if use /dev/ttymxc0 as kgdb console as well as system
console, ttymxc0 is initialized early by system console which does enable
TXEN bit.But when use /dev/ttymxc1 as kgbd console, ttymxc1 is only
initialized by imx_poll_init() cannot enable the TXEN bit, which will
cause kernel panic.

Signed-off-by: Mingrui Ren <jiladahe1997@gmail.com>
Link: https://lore.kernel.org/r/20201202072543.151-1-972931182@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index e5ed4ab2b08df..982953db58e95 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1811,7 +1811,7 @@ static int imx_uart_poll_init(struct uart_port *port)
 	ucr1 |= UCR1_UARTEN;
 	ucr1 &= ~(UCR1_TRDYEN | UCR1_RTSDEN | UCR1_RRDYEN);
 
-	ucr2 |= UCR2_RXEN;
+	ucr2 |= UCR2_RXEN | UCR2_TXEN;
 	ucr2 &= ~UCR2_ATEN;
 
 	imx_uart_writel(sport, ucr1, UCR1);
-- 
2.27.0

