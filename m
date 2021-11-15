Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9A450E77
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhKOSPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237873AbhKOSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94ADD633A0;
        Mon, 15 Nov 2021 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998320;
        bh=Ox9GGarjKrJ43zzWDMJIOhOgpbbTPKCURK2YLUmFtjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVrfF2Yq05zbQuNYlSQwNghrSOiP63eNw9Q7YnjmUXNH+Eq0I7w4fOgyrOT3YacVW
         /HQV6NZ9HK7WuIuS5F76a2f91GG0yU+fgAL+Z998ImztEC/mk5rZcSULIAks5Fg+LH
         xn93gMjiYZaPI4VHuTG0S9NuC4wBw73PwSz7hGao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/575] pinctrl: renesas: checker: Fix off-by-one bug in drive register check
Date:   Mon, 15 Nov 2021 18:02:39 +0100
Message-Id: <20211115165358.784783019@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index c528c124fb0e9..9d168b90cd281 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -890,7 +890,7 @@ static void __init sh_pfc_check_drive_reg(const struct sh_pfc_soc_info *info,
 		if (!field->pin && !field->offset && !field->size)
 			continue;
 
-		mask = GENMASK(field->offset + field->size, field->offset);
+		mask = GENMASK(field->offset + field->size - 1, field->offset);
 		if (mask & seen)
 			sh_pfc_err("drive_reg 0x%x: field %u overlap\n",
 				   drive->reg, i);
-- 
2.33.0



