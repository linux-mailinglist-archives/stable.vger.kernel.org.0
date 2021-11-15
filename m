Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7F451EA1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348080AbhKPAgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345032AbhKOT0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A8D63213;
        Mon, 15 Nov 2021 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003344;
        bh=Yo6T0HmG8a4MTeLKQSYbbIo+YmDuXIyL06Yfb6G+iJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv6QCCBI8gEK6SHKncLX87A0MPAGBK2BFTsRkboIwmt+a1drrSblN06+J7VpPGM5z
         bTEZ7Xn7TC4E1UtcdY9wAGK+JmPJ/11UdySn62KhLN3vv6F7xr3A3oAr1A+zVt0acr
         nIqx4CCc6IvoQeKC+A8UctN5j0UdYk0beJhM8/A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 900/917] mtd: rawnand: gpio: Keep the driver compatible with on-die ECC engines
Date:   Mon, 15 Nov 2021 18:06:35 +0100
Message-Id: <20211115165459.560510021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b5b5b4dc6fcd8194b9dd38c8acdc5ab71adf44f8 upstream.

Following the introduction of the generic ECC engine infrastructure, it
was necessary to reorganize the code and move the ECC configuration in
the ->attach_chip() hook. Failing to do that properly lead to a first
series of fixes supposed to stabilize the situation. Unfortunately, this
only fixed the use of software ECC engines, preventing any other kind of
engine to be used, including on-die ones.

It is now time to (finally) fix the situation by ensuring that we still
provide a default (eg. software ECC) but will still support different
ECC engines such as on-die ECC engines if properly described in the
device tree.

There are no changes needed on the core side in order to do this, but we
just need to leverage the logic there which allows:
1- a subsystem default (set to Host engines in the raw NAND world)
2- a driver specific default (here set to software ECC engines)
3- any type of engine requested by the user (ie. described in the DT)

As the raw NAND subsystem has not yet been fully converted to the ECC
engine infrastructure, in order to provide a default ECC engine for this
driver we need to set chip->ecc.engine_type *before* calling
nand_scan(). During the initialization step, the core will consider this
entry as the default engine for this driver. This value may of course
be overloaded by the user if the usual DT properties are provided.

Fixes: f6341f6448e0 ("mtd: rawnand: gpio: Move the ECC initialization to ->attach_chip()")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210928222258.199726-4-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpio.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/gpio.c
+++ b/drivers/mtd/nand/raw/gpio.c
@@ -163,9 +163,8 @@ static int gpio_nand_exec_op(struct nand
 
 static int gpio_nand_attach_chip(struct nand_chip *chip)
 {
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-
-	if (chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT &&
+	    chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
 		chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
 
 	return 0;
@@ -365,6 +364,13 @@ static int gpio_nand_probe(struct platfo
 	if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
 		gpiod_direction_output(gpiomtd->nwp, 1);
 
+	/*
+	 * This driver assumes that the default ECC engine should be TYPE_SOFT.
+	 * Set ->engine_type before registering the NAND devices in order to
+	 * provide a driver specific default value.
+	 */
+	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
+
 	ret = nand_scan(chip, 1);
 	if (ret)
 		goto err_wp;


