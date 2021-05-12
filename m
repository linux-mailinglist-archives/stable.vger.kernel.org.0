Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279D437C454
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhELPae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235036AbhELP0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5055061982;
        Wed, 12 May 2021 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832278;
        bh=L6FZUSPrXFNc2fmHnnmd9k6ISPJpUBmPxwvwj90l3pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsmVYMtnzV0Fc8R0lLKqxvo3Cy1vZT3MxeMu9LWhprjh0fZErAuEUeU7NQw6+gD/T
         qGH9JLDNcHffsTWyiPPyd5MAnn9xNu6rll/CPmypiaQLj/ivj8Xbf/K1DcqEVfNr8x
         H2V5lPdKoQTPxXxFuplQqnkTfIpLZsP3Q8pyfZ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/530] staging: greybus: uart: fix unprivileged TIOCCSERIAL
Date:   Wed, 12 May 2021 16:45:23 +0200
Message-Id: <20210512144826.844542228@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 60c6b305c11b5fd167ce5e2ce42f3a9098c388f0 ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

A non-privileged user has only ever been able to set the since long
deprecated ASYNC_SPD flags and trying to change any other *supported*
feature should result in -EPERM being returned. Setting the current
values for any supported features should return success.

Fix the greybus implementation which instead indicated that the
TIOCSSERIAL ioctl was not even implemented when a non-privileged user
set the current values.

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-7-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 29846dc1e1bf..a520f7f213db 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -641,8 +641,6 @@ static int set_serial_info(struct tty_struct *tty,
 		if ((close_delay != gb_tty->port.close_delay) ||
 		    (closing_wait != gb_tty->port.closing_wait))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
 	} else {
 		gb_tty->port.close_delay = close_delay;
 		gb_tty->port.closing_wait = closing_wait;
-- 
2.30.2



