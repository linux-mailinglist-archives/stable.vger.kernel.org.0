Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC84649A32C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364977AbiAXXt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455409AbiAXVfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0344C05A183;
        Mon, 24 Jan 2022 12:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF8A61383;
        Mon, 24 Jan 2022 20:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50185C340E5;
        Mon, 24 Jan 2022 20:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055739;
        bh=B4uadrCG/JO5wAor5xYJ7HGh84FA/qtEttragrSIf7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnV02ajWtB2JdwL0/hZeaYuayrsem3uZcA151+91kc0VhK8zwmuXIGQnGzbeHqikh
         t1DRpqwSPpweA+igISWWr8FXfxl27aJRuuwybTbWbCPRIuh9nP/YugRbYFrXfvnBHq
         SifnJ5mgkRUFBvTgZk9MdmaY8pWr5VK2qDGBalXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/846] net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
Date:   Mon, 24 Jan 2022 19:36:06 +0100
Message-Id: <20220124184109.532229695@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit cad1798d2d0811ded37d1e946c6796102e58013b ]

Allow PTP peer delay measurements on blocked ports by STP. In case of topology
changes the PTP stack can directly start with the correct delays.

Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 1469e41f2045a..2dd1227e0c357 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1069,7 +1069,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.portmask     = 0x03,	/* Management ports */
 		.age	      = 0,
 		.is_obt	      = 0,
-		.pass_blocked = 0,
+		.pass_blocked = 1,
 		.is_static    = 1,
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
-- 
2.34.1



