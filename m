Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6068E45769E
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbhKSSrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:47:10 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:43913 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbhKSSrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:47:09 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id B37111C0004;
        Fri, 19 Nov 2021 18:44:05 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mtd: rawnand/davinci: Avoid duplicated page read
Date:   Fri, 19 Nov 2021 19:44:05 +0100
Message-Id: <20211119184405.1404555-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211016132228.40254-2-paul@crapouillou.net>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'9c9d709965385de5a99f84b14bd5860e1541729e'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-10-16 at 13:22:25 UTC, Paul Cercueil wrote:
> The function nand_davinci_read_page_hwecc_oob_first() first reads the
> OOB data, extracts the ECC information, programs the ECC hardware before
> reading the actual data in a loop.
> 
> Right after the OOB data was read, it called nand_read_page_op() to
> reset the read cursor to the beginning of the page. This caused the
> first page to be read twice: in that call, and later in the loop.
> 
> Address that issue by changing the call to nand_read_page_op() to
> nand_change_read_column_op(), which will only reset the read cursor.
> 
> Cc: <stable@vger.kernel.org> # v5.2
> Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
