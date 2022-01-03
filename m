Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104A5483263
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiACO1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiACO0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57C4C061373;
        Mon,  3 Jan 2022 06:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8553C61120;
        Mon,  3 Jan 2022 14:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441DCC36AEB;
        Mon,  3 Jan 2022 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219993;
        bh=N5UoBHgJhKFMGmYGs/nPkT1eIO0SNnC43uII6LHSJTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMpOg7dHBAJrXGnE1Zf71EK2ZAlOIWyk5MZgcHETiO7orAeUZPX/AupO9RhLLFALX
         dKziYVRs49qKDbZZVBxS8bPgh4NcafZdX7S+Uccg8fzUHNUAJXBgpvOnIMfcmIjMq3
         kKI8NRTa/N3IPKi2wLyEl/xioykUVgugSwDub4+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/37] net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
Date:   Mon,  3 Jan 2022 15:23:52 +0100
Message-Id: <20220103142052.316070279@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ]

The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
pointers, using NULL checking to fix this.i

Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211224021500.10362-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 4190f9ed5313d..9afb09c3eba1a 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -245,8 +245,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
 		gpiod = fixed_phy_get_gpiod(np);
-		if (IS_ERR(gpiod))
-			return ERR_CAST(gpiod);
+		if (!gpiod)
+			return ERR_PTR(-EINVAL);
 	}
 
 	/* Get the next available PHY address, up to PHY_MAX_ADDR */
-- 
2.34.1



