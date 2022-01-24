Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60BF499798
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448828AbiAXVNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352884AbiAXVHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AF4AB8122A;
        Mon, 24 Jan 2022 21:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8308DC340E5;
        Mon, 24 Jan 2022 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058448;
        bh=dshKwD90z+e4wGtfVuUQB/JeJSaBr+zQf1ZJXNHxZwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8i0r7YuIBuSjYXuhWQrJK1GVYr4bEQODdgO271M2dIdhlEQRoYoJKwv5WPknchMG
         XPaq3DJ/ZA9t6G8NreBJMor/78Bof99OXDbbe3jgMgwoEOTHv2S3N8YBr4tayjcGKh
         XczrMvg2xGNgmMzAp1hCgOk9EvyPxBllTAxFsup0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0291/1039] net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
Date:   Mon, 24 Jan 2022 19:34:40 +0100
Message-Id: <20220124184135.058794109@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index b488990b5b06e..40ce8c0c9167a 100644
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



