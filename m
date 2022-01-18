Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7258349152E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiARC0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245276AbiARCX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0EB1B81247;
        Tue, 18 Jan 2022 02:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E76C36AE3;
        Tue, 18 Jan 2022 02:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472604;
        bh=iJWsnEH3EqlFoyUdRdRa/2WUrAEJb4H3pNL5VUzpUbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWsFXEZCMdZw3YBq0Jh02BqE7vF3uwtO5M5GkrYvdQ4B0NNN+EXhlT+/g/nJdD992
         ad4qcPUmotWIo1rzd4tzd+LmxVdgTAd6BtkeU3hvq+PC/rK8zDVpQU6Z3pQjwh7U8F
         OkUFQi4J/Pp5Txl+jTs4j5V+xBupfzJRRi/wy/QVFBSuog7iANghTUm8K32tXl+ssX
         ynVV2GY/A7f5Wd53IhFsRf6ZYtNp4o16OEFJBTfxRt65/OcllS5kwMk/USNFGnPOB7
         /vEBx4d0OqoyUZRny/DqXckvrvux73XklhYniejwXst7K3O4QKFzE/znV9IAZQ56GG
         GnLwp6hH7WcGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 068/217] mxser: increase buf_overrun if tty_insert_flip_char() fails
Date:   Mon, 17 Jan 2022 21:17:11 -0500
Message-Id: <20220118021940.1942199-68-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit eb68ac0462bffc2ceb63b3a76737d6c9f186e6de ]

mxser doesn't increase port->icount.buf_overrun at all. Do so if overrun
happens, so that it can be read from the stats.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211118073125.12283-17-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/mxser.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 3b5d193b7f245..39458b42df7b0 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1536,7 +1536,8 @@ static bool mxser_receive_chars_new(struct tty_struct *tty,
 
 	while (gdl--) {
 		u8 ch = inb(port->ioaddr + UART_RX);
-		tty_insert_flip_char(&port->port, ch, 0);
+		if (!tty_insert_flip_char(&port->port, ch, 0))
+			port->icount.buf_overrun++;
 	}
 
 	return true;
@@ -1582,8 +1583,10 @@ static u8 mxser_receive_chars_old(struct tty_struct *tty,
 					port->icount.overrun++;
 				}
 			}
-			if (!tty_insert_flip_char(&port->port, ch, flag))
+			if (!tty_insert_flip_char(&port->port, ch, flag)) {
+				port->icount.buf_overrun++;
 				break;
+			}
 		}
 
 		if (hwid)
-- 
2.34.1

