Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B42457697
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhKSSqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:46:45 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:44837 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbhKSSqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:46:44 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id F37EE40002;
        Fri, 19 Nov 2021 18:43:39 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Christian Eggers <ceggers@arri.de>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Riedmueller <S.Riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>, Greg Ungerer <gerg@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Christian Hemp <C.Hemp@phytec.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Stefan Riedmueller" <s.riedmueller@phytec.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] gpmi-nand: Add ERR007117 protection for nfc_apply_timings
Date:   Fri, 19 Nov 2021 19:43:39 +0100
Message-Id: <20211119184339.1404232-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211102202022.15551-2-ceggers@arri.de>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'f53d4c109a666bf1a4883b45d546fba079258717'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-02 at 20:20:22 UTC, Christian Eggers wrote:
> gpmi_io clock needs to be gated off when changing the parent/dividers of
> enfc_clk_root (i.MX6Q/i.MX6UL) respectively qspi2_clk_root (i.MX6SX).
> Otherwise this rate change can lead to an unresponsive GPMI core which
> results in DMA timeouts and failed driver probe:
> 
> [    4.072318] gpmi-nand 112000.gpmi-nand: DMA timeout, last DMA
> ...
> [    4.370355] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -110
> ...
> [    4.375988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> [    4.381524] gpmi-nand 112000.gpmi-nand: Error in ECC-based read: -22
> [    4.387988] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> [    4.393535] gpmi-nand 112000.gpmi-nand: Chip: 0, Error -22
> ...
> 
> Other than stated in i.MX 6 erratum ERR007117, it should be sufficient
> to gate only gpmi_io because all other bch/nand clocks are derived from
> different clock roots.
> 
> The i.MX6 reference manuals state that changing clock muxers can cause
> glitches but are silent about changing dividers. But tests showed that
> these glitches can definitely happen on i.MX6ULL. For i.MX7D/8MM in turn,
> the manual guarantees that no glitches can happen when changing
> dividers.
> 
> Co-developed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> Acked-by: Han Xu <han.xu@nxp.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
