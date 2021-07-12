Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B78E3C4BE8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhGLHAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242013AbhGLG7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D0D61132;
        Mon, 12 Jul 2021 06:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073012;
        bh=DHtccH3ewspNl1D5JPSeZgPSD9xFMj9+CdsdE60Z/ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfIUwpXpO3Ehs4eJ8GRazj2b8Gmj1Bjdxl+T/Cdpaju0x6PYK26+8KnG0M4/u+kPo
         AwTgGw81kZvgw16rplcWAhoKgJ20akIiRGLWuVP26xItIshX3aKGBLiCWGq/f1DZ+z
         k8boAFGIzUcF8YlOJWg0NKIK3e/Lo63WgNOWPy0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>
Subject: [PATCH 5.12 097/700] serial_cs: remove wrong GLOBETROTTER.cis entry
Date:   Mon, 12 Jul 2021 08:03:00 +0200
Message-Id: <20210712060938.503258505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

commit 11b1d881a90fc184cc7d06e9804eb288c24a2a0d upstream.

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
 drivers/tty/serial/8250/serial_cs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -805,7 +805,6 @@ static const struct pcmcia_device_id ser
 	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-4", 0x96913a85, 0xcec8f102, "cis/COMpad4.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID123("ADVANTECH", "COMpad-32/85", "1.0", 0x96913a85, 0x8fbe92ae, 0x0877b627, "cis/COMpad2.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "cis/RS-COM-2P.cis"),
-	PCMCIA_DEVICE_CIS_MANF_CARD(0x0013, 0x0000, "cis/GLOBETROTTER.cis"),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100  1.00.", 0x19ca78af, 0xf964f42b),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100", 0x19ca78af, 0x71d98e83),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL232  1.00.", 0x19ca78af, 0x69fb7490),


