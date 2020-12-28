Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC12E3A83
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390855AbgL1Nhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390849AbgL1Nhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 463AB206ED;
        Mon, 28 Dec 2020 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162624;
        bh=kiJ2+GqyRVZgCvnsQHCwJEY8IcyC9mVhEuH60XNylBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYImU8/KWgIrCCe2s83nVYG9FTo0cCq38fS/C0XqbrFGVEQC+YUlyBIeLcdiaDGEG
         CuhcxRIXYlb08QJ4wk0n4E6rTqlYQrtx2gNHxNwgMPiPQvxHZvoDSfKxQ2yFHo9Xax
         JAwmCSVkkAtteYJqI/CSNjM8SIKPvmqo03V4pj8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/453] clk: renesas: r9a06g032: Drop __packed for portability
Date:   Mon, 28 Dec 2020 13:44:13 +0100
Message-Id: <20201228124938.078550427@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ceabbf94c317c6175dee6e91805fca4a6353745a ]

The R9A06G032 clock driver uses an array of packed structures to reduce
kernel size.  However, this array contains pointers, which are no longer
aligned naturally, and cannot be relocated on PPC64.  Hence when
compile-testing this driver on PPC64 with CONFIG_RELOCATABLE=y (e.g.
PowerPC allyesconfig), the following warnings are produced:

    WARNING: 136 bad relocations
    c000000000616be3 R_PPC64_UADDR64   .rodata+0x00000000000cf338
    c000000000616bfe R_PPC64_UADDR64   .rodata+0x00000000000cf370
    ...

Fix this by dropping the __packed attribute from the r9a06g032_clkdesc
definition, trading a small size increase for portability.

This increases the 156-entry clock table by 1 byte per entry, but due to
the compiler generating more efficient code for unpacked accesses, the
net size increase is only 76 bytes (gcc 9.3.0 on arm32).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 4c3d88526eba2143 ("clk: renesas: Renesas R9A06G032 clock driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20201130085743.1656317-1-geert+renesas@glider.be
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> # PowerPC allyesconfig build
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index 1907ee195a08c..f2dc625b745da 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -55,7 +55,7 @@ struct r9a06g032_clkdesc {
 			u16 sel, g1, r1, g2, r2;
 		} dual;
 	};
-} __packed;
+};
 
 #define I_GATE(_clk, _rst, _rdy, _midle, _scon, _mirack, _mistat) \
 	{ .gate = _clk, .reset = _rst, \
-- 
2.27.0



