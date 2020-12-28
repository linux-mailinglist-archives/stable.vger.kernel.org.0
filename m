Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4251B2E4072
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgL1OwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502029AbgL1OSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9F9B206D4;
        Mon, 28 Dec 2020 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165113;
        bh=nGCLY8IT6dAMWqZXpIhlhyg/Rhh9fWVJzV5hz+KEYQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuInG9wyxq98g9H3fLXH9zG0Wj83ox3N0Et/IfCHxxE035hC2V33Fw2xYIU9aeNoR
         KTpeICG35cM8R35uzymFDMOWE9O21/8cLiLGe1z26PmM1QnUcpDcBHTW4X/TspvOF4
         gMRNa0w0dcir1PTfXtSG82DK30L+YLYKdn4fmU68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/717] mtd: rawnand: meson: Fix a resource leak in init
Date:   Mon, 28 Dec 2020 13:46:47 +0100
Message-Id: <20201228125040.575969990@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 48e6dac96be6d..1fd7f7024c0b4 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1044,9 +1044,12 @@ static int meson_nfc_clk_init(struct meson_nfc *nfc)
 
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



