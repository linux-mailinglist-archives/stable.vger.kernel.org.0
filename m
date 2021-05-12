Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D79F37C89D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhELQLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238628AbhELQFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A656D61CE8;
        Wed, 12 May 2021 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833671;
        bh=+lrkiU/LuudPPNZXSfuLmMdIO6mIg3MnqG45CYPeOXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy1EwpvYzAi9ypqLfyIGTUl342EcSM3P2Zeq3CC5CT8nQf7MGTg1ms4mRlw/CEmRC
         ji2ZzFDBp9a3ckRkEDl+QUY0aEkO8eaBwd3WUMquhDcQM8REYtnQx8TnPdaLDtrjlV
         Zk9XhRKrF1b9kLEp9+6OiY/CDYwPqLw4T7577Ag8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 242/601] staging: fwserial: fix TIOCGSERIAL implementation
Date:   Wed, 12 May 2021 16:45:19 +0200
Message-Id: <20210512144835.802090425@linuxfoundation.org>
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

[ Upstream commit 5e84a66f3682af4f177bb24bb2ad5135c51f764a ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

The xmit_fifo_size parameter could be used to set the hardware transmit
fifo size of a legacy UART when it could not be detected, but the
interface is limited to eight bits and should be left unset when not
used.

Fix the fwserial implementation by dropping its custom interpretation of
the unused xmit_fifo_size field, which was overflowed with the driver
FIFO size. Also leave the type and flags fields unset as these cannot be
changed.

The close_delay and closing_wait parameters returned by TIOCGSERIAL are
specified in centiseconds. The driver does not yet support changing
closing_wait, but let's report back the default value actually used (30
seconds).

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fwserial/fwserial.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 2888b80a2c1a..0f4655d7d520 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1218,13 +1218,12 @@ static int get_serial_info(struct tty_struct *tty,
 	struct fwtty_port *port = tty->driver_data;
 
 	mutex_lock(&port->port.mutex);
-	ss->type =  PORT_UNKNOWN;
-	ss->line =  port->port.tty->index;
-	ss->flags = port->port.flags;
-	ss->xmit_fifo_size = FWTTY_PORT_TXFIFO_LEN;
+	ss->line = port->index;
 	ss->baud_base = 400000000;
 	ss->close_delay = jiffies_to_msecs(port->port.close_delay) / 10;
+	ss->closing_wait = 3000;
 	mutex_unlock(&port->port.mutex);
+
 	return 0;
 }
 
-- 
2.30.2



