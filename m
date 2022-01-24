Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2501D499939
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454862AbiAXVd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:33:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452215AbiAXVYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:24:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60E861320;
        Mon, 24 Jan 2022 21:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A5AC340E4;
        Mon, 24 Jan 2022 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059459;
        bh=iJWsnEH3EqlFoyUdRdRa/2WUrAEJb4H3pNL5VUzpUbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qd57NVl2iUDNZZFn5WQxJaKWFUHPdtDsKahxmeuikE+73gH3KdAFAZanjyNqsDvba
         s96ayB3WYgtjekQcIKiyTax2Pqh6/C498Preb3MHYMh2f1gVKhGiHZYnG/K00u7s1B
         Gh04ZePS0+BDoGcCGxBK3IJIqk/bHXLuEnFP1sZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0590/1039] mxser: increase buf_overrun if tty_insert_flip_char() fails
Date:   Mon, 24 Jan 2022 19:39:39 +0100
Message-Id: <20220124184145.165420298@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



