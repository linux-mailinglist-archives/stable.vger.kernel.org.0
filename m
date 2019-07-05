Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2DC60CE2
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 23:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfGEVAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 17:00:25 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40797 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEVAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 17:00:24 -0400
X-Originating-IP: 91.224.148.103
Received: from localhost.localdomain (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 107921BF207;
        Fri,  5 Jul 2019 21:00:19 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Richard Weinberger <richard@nod.at>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>, od@zcrc.me,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: rawnand: ingenic: Fix ingenic_ecc dependency
Date:   Fri,  5 Jul 2019 23:00:13 +0200
Message-Id: <20190705210013.13355-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190629012248.12447-1-paul@crapouillou.net>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: c403ec33b613a15d9fd8dde37f246b79cd56b5df
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2019-06-29 at 01:22:48 UTC, Paul Cercueil wrote:
> If MTD_NAND_JZ4780 is y and MTD_NAND_JZ4780_BCH is m,
> which select CONFIG_MTD_NAND_INGENIC_ECC to m, building fails:
> 
> drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_remove':
> ingenic_nand.c:(.text+0x177): undefined reference to `ingenic_ecc_release'
> drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_ecc_correct':
> ingenic_nand.c:(.text+0x2ee): undefined reference to `ingenic_ecc_correct'
> 
> To fix that, the ingenic_nand and ingenic_ecc modules have been fused
> into one single module.
> - The ingenic_ecc.c code is now compiled in only if
>   $(CONFIG_MTD_NAND_INGENIC_ECC) is set. This is now a boolean instead
>   of tristate.
> - To avoid changing the module name, the ingenic_nand.c file is moved to
>   ingenic_nand_drv.c. Then the module name is still ingenic_nand.
> - Since ingenic_ecc.c is no more a module, the module-specific macros
>   have been dropped, and the functions are no more exported for use by
>   the ingenic_nand driver.
> 
> Fixes: 15de8c6efd0e ("mtd: rawnand: ingenic: Separate top-level and SoC specific code")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
