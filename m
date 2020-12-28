Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A972E3B78
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406348AbgL1Nub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406314AbgL1Nub (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B1B1208B3;
        Mon, 28 Dec 2020 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163390;
        bh=2BKQVLwBXQA3mHZ4MLRKHByj5CIapqzWwFWOLkVNcdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SW0SbtOl0WAJNr48TdVfTNst8UPgTbPX0MzZXEQJEispVxbTHtLAAk6sXSWGXVv5P
         2IW+CqnUBKnWRoOq1FU6rXFqg21Cu6pG5+0FVo+6p2wfRO3n9kRReghx3lL7/mIKS7
         Dx8L30HfcHxvWakEL+m6OtnMSAc6R+hD94zKkiWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 268/453] mtd: rawnand: meson: Fix a resource leak in init
Date:   Mon, 28 Dec 2020 13:48:24 +0100
Message-Id: <20201228124950.124035517@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ad8566d3555c4731e6b48823b92d3929b0394c14 ]

Call clk_disable_unprepare(nfc->phase_rx) if the clk_set_rate() function
fails to avoid a resource leak.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/X8ikVCnUsfTpffFB@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 1b82b687e5a50..58eaa3845da4d 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1041,9 +1041,12 @@ static int meson_nfc_clk_init(struct meson_nfc *nfc)
 
 	ret = clk_set_rate(nfc->device_clk, 24000000);
 	if (ret)
-		goto err_phase_rx;
+		goto err_disable_rx;
 
 	return 0;
+
+err_disable_rx:
+	clk_disable_unprepare(nfc->phase_rx);
 err_phase_rx:
 	clk_disable_unprepare(nfc->phase_tx);
 err_phase_tx:
-- 
2.27.0



