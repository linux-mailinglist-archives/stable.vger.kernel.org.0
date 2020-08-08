Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344BB23FB18
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHHXrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgHHXiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B372073E;
        Sat,  8 Aug 2020 23:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929879;
        bh=LgP2OlZL56NdcDzxmOX1Pp5E0+D4FDy8ClRGYt4r8wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dksMcNo8fujg2wYkfT/CRXdwqmLwih0zPk1VDLwaM8VW93kKVzBLUEz4gPc9QrSO2
         gzFC3mLnjpC29R5Yq0MSZPFzyJzAOvkVLsEEjAOySYMlBTeiLSPm2X6wueWMbLKmMU
         rwIM8Pa+OXI7WON9iuowEtp0QJi57Ua9PI8JjR3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.7 25/58] m68k: mac: Don't send IOP message until channel is idle
Date:   Sat,  8 Aug 2020 19:36:51 -0400
Message-Id: <20200808233724.3618168-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9bfa170157688..d8f2282978f9c 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -416,7 +416,8 @@ static void iop_handle_send(uint iop_num, uint chan)
 	msg->status = IOP_MSGSTATUS_UNUSED;
 	msg = msg->next;
 	iop_send_queue[iop_num][chan] = msg;
-	if (msg) iop_do_send(msg);
+	if (msg && iop_readb(iop, IOP_ADDR_SEND_STATE + chan) == IOP_MSG_IDLE)
+		iop_do_send(msg);
 }
 
 /*
@@ -490,16 +491,12 @@ int iop_send_message(uint iop_num, uint chan, void *privdata,
 
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

