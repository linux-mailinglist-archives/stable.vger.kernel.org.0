Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE97B42EED3
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbhJOKeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 06:34:08 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50813 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbhJOKeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 06:34:04 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9211B1BF20B;
        Fri, 15 Oct 2021 10:31:55 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jan Hoffmann <jan@3e8.eu>,
        Kestrel seventyfour <kestrelseventyfour@gmail.com>
Subject: Re: [PATCH 9/9] mtd: rawnand: xway: Keep the driver compatible with on-die ECC engines
Date:   Fri, 15 Oct 2021 12:31:55 +0200
Message-Id: <20211015103155.949385-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210928222258.199726-10-miquel.raynal@bootlin.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'6bcd2960af1b7bacb2f1e710ab0c0b802d900501'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-09-28 at 22:22:48 UTC, Miquel Raynal wrote:
> Following the introduction of the generic ECC engine infrastructure, it
> was necessary to reorganize the code and move the ECC configuration in
> the ->attach_chip() hook. Failing to do that properly lead to a first
> series of fixes supposed to stabilize the situation. Unfortunately, this
> only fixed the use of software ECC engines, preventing any other kind of
> engine to be used, including on-die ones.
> 
> It is now time to (finally) fix the situation by ensuring that we still
> provide a default (eg. software ECC) but will still support different
> ECC engines such as on-die ECC engines if properly described in the
> device tree.
> 
> There are no changes needed on the core side in order to do this, but we
> just need to leverage the logic there which allows:
> 1- a subsystem default (set to Host engines in the raw NAND world)
> 2- a driver specific default (here set to software ECC engines)
> 3- any type of engine requested by the user (ie. described in the DT)
> 
> As the raw NAND subsystem has not yet been fully converted to the ECC
> engine infrastructure, in order to provide a default ECC engine for this
> driver we need to set chip->ecc.engine_type *before* calling
> nand_scan(). During the initialization step, the core will consider this
> entry as the default engine for this driver. This value may of course
> be overloaded by the user if the usual DT properties are provided.
> 
> Fixes: d525914b5bd8 ("mtd: rawnand: xway: Move the ECC initialization to ->attach_chip()")
> Cc: stable@vger.kernel.org
> Cc: Jan Hoffmann <jan@3e8.eu>
> Cc: Kestrel seventyfour <kestrelseventyfour@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Tested-by: Jan Hoffmann <jan@3e8.eu>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next.

Miquel
