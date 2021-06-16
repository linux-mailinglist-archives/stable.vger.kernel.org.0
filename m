Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87123A93AC
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFPHY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231376AbhFPHY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 03:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5C36128C;
        Wed, 16 Jun 2021 07:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623828141;
        bh=A5BvpVSxcENz57MJAWHc+R3LvgRuu07iAAZzCe/XSIc=;
        h=Subject:To:From:Date:From;
        b=KxjFedPA3GoUdJrunsfg2t0dGKxmahu6szCXzx3ueputUjUljWSyVlC2SqR07nWyw
         rRNhHgt/UQqLsN1RqRB6i3QEsIM248VlH6gKoSXupadCbIwtYeuWk/3BVXP90hOVzT
         G256mr4kLH0ZVfNUO2NgGg69JfQamdkQBkcQBUH8=
Subject: patch "serial_cs: remove wrong GLOBETROTTER.cis entry" added to tty-next
To:     linux@zary.sk, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Jun 2021 09:21:52 +0200
Message-ID: <1623828112244227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial_cs: remove wrong GLOBETROTTER.cis entry

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 11b1d881a90fc184cc7d06e9804eb288c24a2a0d Mon Sep 17 00:00:00 2001
From: Ondrej Zary <linux@zary.sk>
Date: Fri, 11 Jun 2021 22:19:39 +0200
Subject: serial_cs: remove wrong GLOBETROTTER.cis entry

The GLOBETROTTER.cis entry in serial_cs matches more devices than
intended and breaks them. Remove it.

Example: # pccardctl info
PRODID_1="Option International
"
PRODID_2="GSM-Ready 56K/ISDN
"
PRODID_3="021
"
PRODID_4="A
"
MANFID=0013,0000
FUNCID=0

result:
pcmcia 0.0: Direct firmware load for cis/GLOBETROTTER.cis failed with error -2

The GLOBETROTTER.cis is nowhere to be found. There's GLOBETROTTER.cis.ihex at
https://netdev.vger.kernel.narkive.com/h4inqdxM/patch-axnet-cs-fix-phy-id-detection-for-bogus-asix-chip#post41
It's from completely diffetent card:
vers_1 4.1, "Option International", "GSM/GPRS GlobeTrotter", "001", "A"

Signed-off-by: Ondrej Zary <linux@zary.sk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210611201940.23898-1-linux@zary.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/serial_cs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 3708114343b0..2f1d33ea26e1 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -813,7 +813,6 @@ static const struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-4", 0x96913a85, 0xcec8f102, "cis/COMpad4.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID123("ADVANTECH", "COMpad-32/85", "1.0", 0x96913a85, 0x8fbe92ae, 0x0877b627, "cis/COMpad2.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "cis/RS-COM-2P.cis"),
-	PCMCIA_DEVICE_CIS_MANF_CARD(0x0013, 0x0000, "cis/GLOBETROTTER.cis"),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100  1.00.", 0x19ca78af, 0xf964f42b),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100", 0x19ca78af, 0x71d98e83),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL232  1.00.", 0x19ca78af, 0x69fb7490),
-- 
2.32.0


