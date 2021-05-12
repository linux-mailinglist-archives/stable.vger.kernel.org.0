Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF2737C892
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhELQKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238624AbhELQFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1654E61CE9;
        Wed, 12 May 2021 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833673;
        bh=L6FZUSPrXFNc2fmHnnmd9k6ISPJpUBmPxwvwj90l3pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRc9vHaFNetyyJGQZP6FsNMGwFvLZv/c0fkCrVsFIT6LmNpycz7H0fPWrGPaAc5Nn
         2dlPbFg66Dj9y2rYpBJ5Apy7lZzQ4dfuz1RmdU5dwkmV89uLK1BCz8g4qQ8tMZjIFz
         gNu6kFBywroVDef9Z3ERrxrSazAWxk+n4IGANM/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 243/601] staging: greybus: uart: fix unprivileged TIOCCSERIAL
Date:   Wed, 12 May 2021 16:45:20 +0200
Message-Id: <20210512144835.833534527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



