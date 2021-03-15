Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9C33B62F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCON5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhCON4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4467364EEC;
        Mon, 15 Mar 2021 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816610;
        bh=JSO7HjCPXzECWUoqg072bc6aHfuQwXZ6MlP0UVke4xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jo6D/wMkopTw3DbBRRKbaUdT1im7Z/lAm4RgUGznMHM6XaWohuU/f6EYnTN+kLrar
         nh2jzufYsEA9iRT5dHEWOt2RVS7kxmfDZ0OraaFdHdhjC31zsqHb973EqA9slZwFNw
         Nl5VE8lpZ0/UVhTRBzo9FL/M5LvZS6t9tJUxMHUU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zbynek Michl <zbynek.michl@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 003/168] ethernet: alx: fix order of calls on resume
Date:   Mon, 15 Mar 2021 14:53:55 +0100
Message-Id: <20210315135550.448416136@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jakub Kicinski <kuba@kernel.org>

commit a4dcfbc4ee2218abd567d81d795082d8d4afcdf6 upstream.

netif_device_attach() will unpause the queues so we can't call
it before __alx_open(). This went undetected until
commit b0999223f224 ("alx: add ability to allocate and free
alx_napi structures") but now if stack tries to xmit immediately
on resume before __alx_open() we'll crash on the NAPI being null:

 BUG: kernel NULL pointer dereference, address: 0000000000000198
 CPU: 0 PID: 12 Comm: ksoftirqd/0 Tainted: G           OE 5.10.0-3-amd64 #1 Debian 5.10.13-1
 Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77-D3H, BIOS F15 11/14/2013
 RIP: 0010:alx_start_xmit+0x34/0x650 [alx]
 Code: 41 56 41 55 41 54 55 53 48 83 ec 20 0f b7 57 7c 8b 8e b0
0b 00 00 39 ca 72 06 89 d0 31 d2 f7 f1 89 d2 48 8b 84 df
 RSP: 0018:ffffb09240083d28 EFLAGS: 00010297
 RAX: 0000000000000000 RBX: ffffa04d80ae7800 RCX: 0000000000000004
 RDX: 0000000000000000 RSI: ffffa04d80afa000 RDI: ffffa04e92e92a00
 RBP: 0000000000000042 R08: 0000000000000100 R09: ffffa04ea3146700
 R10: 0000000000000014 R11: 0000000000000000 R12: ffffa04e92e92100
 R13: 0000000000000001 R14: ffffa04e92e92a00 R15: ffffa04e92e92a00
 FS:  0000000000000000(0000) GS:ffffa0508f600000(0000) knlGS:0000000000000000
 i915 0000:00:02.0: vblank wait timed out on crtc 0
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000198 CR3: 000000004460a001 CR4: 00000000001706f0
 Call Trace:
  dev_hard_start_xmit+0xc7/0x1e0
  sch_direct_xmit+0x10f/0x310

Cc: <stable@vger.kernel.org> # 4.9+
Fixes: bc2bebe8de8e ("alx: remove WoL support")
Reported-by: Zbynek Michl <zbynek.michl@gmail.com>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Zbynek Michl <zbynek.michl@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/alx/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1897,13 +1897,16 @@ static int alx_resume(struct device *dev
 
 	if (!netif_running(alx->dev))
 		return 0;
-	netif_device_attach(alx->dev);
 
 	rtnl_lock();
 	err = __alx_open(alx, true);
 	rtnl_unlock();
+	if (err)
+		return err;
+
+	netif_device_attach(alx->dev);
 
-	return err;
+	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);


