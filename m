Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2702A4522A5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbhKPBPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244245AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 642356331F;
        Mon, 15 Nov 2021 18:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000389;
        bh=g84It8D/XAF80OxbteF4BhzVeqgVoB790lpQqdEBBtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/f5ckYdqJPPGm5I+WyIutmpqToIhhKNCQ+L9ptR70M9hwBeSkVLhhT4NE3TlvjRm
         VdfeLHUlX0Dzj+P7AzviKHnpt418RQrB01yrBG8Cqa/8cbfVjpUPyHVdjPDhWRrlv7
         dLWSBrDCduZ9qBlpNO6gFdllUm6qVd7qTxsyIF8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 610/849] pinctrl: renesas: checker: Fix off-by-one bug in drive register check
Date:   Mon, 15 Nov 2021 18:01:33 +0100
Message-Id: <20211115165440.881207583@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 28e7f8ff90583791a034d43b5d2e3fe394142e13 ]

The GENMASK(h, l) macro creates a contiguous bitmask starting at bit
position @l and ending at position @h, inclusive.

This did not trigger any error checks, as the individual register fields
cover at most 3 of the 4 available bits.

Fixes: 08df16e07ad0a1ec ("pinctrl: sh-pfc: checker: Add drive strength register checks")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/8f82d6147fbe3367d4c83962480e97f58d9c96a2.1633615652.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index 5ccc49b387f17..77d1dc0f5b9ba 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -886,7 +886,7 @@ static void __init sh_pfc_check_drive_reg(const struct sh_pfc_soc_info *info,
 		if (!field->pin && !field->offset && !field->size)
 			continue;
 
-		mask = GENMASK(field->offset + field->size, field->offset);
+		mask = GENMASK(field->offset + field->size - 1, field->offset);
 		if (mask & seen)
 			sh_pfc_err("drive_reg 0x%x: field %u overlap\n",
 				   drive->reg, i);
-- 
2.33.0



