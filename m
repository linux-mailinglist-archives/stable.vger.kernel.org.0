Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D2797C8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbfG2TsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbfG2TsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26C720C01;
        Mon, 29 Jul 2019 19:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429684;
        bh=dPWXnPoMNQ/AGftH0Fj6+yl480hMzVScjFP8uUDm/xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZjTVRwCM1J5keUG+WArQitLFOUXmz4ilRdpXJ8tx7wHoraAa4zEqTxLDZdZb2S5W
         vEVeXNC0EPD7ga+bNZLg/IkN8Hav1vi7OjJaeL3hSmdbqhltF4hqeqTiLSs4c1ElYR
         hAc3kpClzBVNUhjrWQoQC9Pq4z4Sh+2ks/Hwlsjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 060/215] sunhv: Fix device naming inconsistency between sunhv_console and sunhv_reg
Date:   Mon, 29 Jul 2019 21:20:56 +0200
Message-Id: <20190729190750.925642226@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 07a6d63eb1b54b5fb38092780fe618dfe1d96e23 ]

In d5a2aa24, the name in struct console sunhv_console was changed from "ttyS"
to "ttyHV" while the name in struct uart_ops sunhv_pops remained unchanged.

This results in the hypervisor console device to be listed as "ttyHV0" under
/proc/consoles while the device node is still named "ttyS0":

root@osaka:~# cat /proc/consoles
ttyHV0               -W- (EC p  )    4:64
tty0                 -WU (E     )    4:1
root@osaka:~# readlink /sys/dev/char/4:64
../../devices/root/f02836f0/f0285690/tty/ttyS0
root@osaka:~#

This means that any userland code which tries to determine the name of the
device file of the hypervisor console device can not rely on the information
provided by /proc/consoles. In particular, booting current versions of debian-
installer inside a SPARC LDOM will fail with the installer unable to determine
the console device.

After renaming the device in struct uart_ops sunhv_pops to "ttyHV" as well,
the inconsistency is fixed and it is possible again to determine the name
of the device file of the hypervisor console device by reading the contents
of /proc/console:

root@osaka:~# cat /proc/consoles
ttyHV0               -W- (EC p  )    4:64
tty0                 -WU (E     )    4:1
root@osaka:~# readlink /sys/dev/char/4:64
../../devices/root/f02836f0/f0285690/tty/ttyHV0
root@osaka:~#

With this change, debian-installer works correctly when installing inside
a SPARC LDOM.

Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sunhv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index 63e34d868de8..f8503f8fc44e 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -397,7 +397,7 @@ static const struct uart_ops sunhv_pops = {
 static struct uart_driver sunhv_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "sunhv",
-	.dev_name		= "ttyS",
+	.dev_name		= "ttyHV",
 	.major			= TTY_MAJOR,
 };
 
-- 
2.20.1



