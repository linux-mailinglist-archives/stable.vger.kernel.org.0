Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C0324B638
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgHTKeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgHTKT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDB620658;
        Thu, 20 Aug 2020 10:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918765;
        bh=XwsNyU6mQKwsM1c/uaHrs4pZwZYGuE8hG/wttSzrgKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJGYTeRwepHUqfAgmcpRpVFUSVwlnH95WOKpyVlIhs0rx/cFnkP1P4Km+NBgadoYr
         1UDcCanM0HqF9ix5OKt+NDj05P5BtQsZIJ1Z4aAewkmCyDv2fRLKTrXg+pb0Th0D5Y
         LB4VBnQeN4EV/esaE9hlpELG2cXAAe3jJUOAqVak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/149] m68k: mac: Dont send IOP message until channel is idle
Date:   Thu, 20 Aug 2020 11:22:15 +0200
Message-Id: <20200820092128.542804314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit aeb445bf2194d83e12e85bf5c65baaf1f093bd8f ]

In the following sequence of calls, iop_do_send() gets called when the
"send" channel is not in the IOP_MSG_IDLE state:

	iop_ism_irq()
		iop_handle_send()
			(msg->handler)()
				iop_send_message()
			iop_do_send()

Avoid this by testing the channel state before calling iop_do_send().

When sending, and iop_send_queue is empty, call iop_do_send() because
the channel is idle. If iop_send_queue is not empty, iop_do_send() will
get called later by iop_handle_send().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Cc: Joshua Thompson <funaho@jurai.org>
Link: https://lore.kernel.org/r/6d667c39e53865661fa5a48f16829d18ed8abe54.1590880333.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/iop.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 4d2adfb32a2ab..c89ed66908f91 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -416,7 +416,8 @@ static void iop_handle_send(uint iop_num, uint chan)
 	iop_free_msg(msg2);
 
 	iop_send_queue[iop_num][chan] = msg;
-	if (msg) iop_do_send(msg);
+	if (msg && iop_readb(iop, IOP_ADDR_SEND_STATE + chan) == IOP_MSG_IDLE)
+		iop_do_send(msg);
 }
 
 /*
@@ -497,16 +498,12 @@ int iop_send_message(uint iop_num, uint chan, void *privdata,
 
 	if (!(q = iop_send_queue[iop_num][chan])) {
 		iop_send_queue[iop_num][chan] = msg;
+		iop_do_send(msg);
 	} else {
 		while (q->next) q = q->next;
 		q->next = msg;
 	}
 
-	if (iop_readb(iop_base[iop_num],
-	    IOP_ADDR_SEND_STATE + chan) == IOP_MSG_IDLE) {
-		iop_do_send(msg);
-	}
-
 	return 0;
 }
 
-- 
2.25.1



