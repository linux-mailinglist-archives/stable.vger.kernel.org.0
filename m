Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3A7451E09
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348931AbhKPAex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344477AbhKOTYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AD463494;
        Mon, 15 Nov 2021 18:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002709;
        bh=uj3be2jnkynNNKzMJN5Qux/b8GpDfGfJPhtpcRs3kD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcUxh2edUzGsXKfhrtWD0eVFiPb0C5I4oWXKFft684RdEHIJJPwCrmjc5h7YOJGls
         cRLPr7hqYXyALCyX/qli3yVrIbTGTAxpidJG2vxejpjE5uwAi4swRBgsVlRILSY5HP
         JDYTtcQzretugUTBKAayj3HTSG98na9fdjd8V+28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 635/917] pinctrl: renesas: checker: Fix off-by-one bug in drive register check
Date:   Mon, 15 Nov 2021 18:02:10 +0100
Message-Id: <20211115165450.343567880@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index f2ab02225837e..f29130957e49a 100644
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



