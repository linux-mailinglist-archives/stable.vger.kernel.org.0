Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FD6450F64
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhKOSac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241143AbhKOS1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:27:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ACCE63439;
        Mon, 15 Nov 2021 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999023;
        bh=hYra+e4a47V+ydyfs1YRzlOCGrI83ATxYV4qKD6WZr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2Qql2XUfu7bL9t0jocuZuSmElZdWYsyNR2h189/bXZpfuIw9mDOsi/3YowL81bbV
         ANb5ufn8QYjHDwt4sLIBvhUuh8SDkT/9pext35EfYsbg8AUE7QAQa/yCLmSLxclRgx
         YcxRbFQ6zMRTvxrZfDCNI0TC8+4CSH3nqyv7PEHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.14 149/849] mtd: rawnand: socrates: Keep the driver compatible with on-die ECC engines
Date:   Mon, 15 Nov 2021 17:53:52 +0100
Message-Id: <20211115165425.183104247@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b4ebddd6540d78a7f977b3fea0261bd575c6ffe2 upstream.

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

Fixes: b36bf0a0fe5d ("mtd: rawnand: socrates: Move the ECC initialization to ->attach_chip()")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210928222258.199726-9-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/socrates_nand.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -119,9 +119,8 @@ static int socrates_nand_device_ready(st
 
 static int socrates_attach_chip(struct nand_chip *chip)
 {
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-
-	if (chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT &&
+	    chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
 		chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
 
 	return 0;
@@ -175,6 +174,13 @@ static int socrates_nand_probe(struct pl
 	/* TODO: I have no idea what real delay is. */
 	nand_chip->legacy.chip_delay = 20;	/* 20us command delay time */
 
+	/*
+	 * This driver assumes that the default ECC engine should be TYPE_SOFT.
+	 * Set ->engine_type before registering the NAND devices in order to
+	 * provide a driver specific default value.
+	 */
+	nand_chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
+
 	dev_set_drvdata(&ofdev->dev, host);
 
 	res = nand_scan(nand_chip, 1);


