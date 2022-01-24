Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1984E499FE9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842343AbiAXXBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838742AbiAXWsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D136AC068097;
        Mon, 24 Jan 2022 13:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625FB60E8D;
        Mon, 24 Jan 2022 21:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B827C340E5;
        Mon, 24 Jan 2022 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058441;
        bh=8e00U0sygiDjy9t1dLdGDBMdtS4FVv8xGfSfW3y8oLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDuvcUxnPJZygDdKezPWYDV3ArJen/JVrnIuhmEW/YV30t2phHKBd7gOuZYLkQTvO
         E/ic5ymnrotZqjvgadaYE7MK6W8L6InHQaZUrrCCmIn8ubA02YdhItQvQAWJzdpa2i
         wBYPUukIVSTxm8W4l/iJauatxM2KfJpmZWRVpYMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0290/1039] net: dsa: hellcreek: Add STP forwarding rule
Date:   Mon, 24 Jan 2022 19:34:39 +0100
Message-Id: <20220124184135.028681639@linuxfoundation.org>
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

[ Upstream commit b7ade35eb53a2455f737a623c24e4b24455b2271 ]

Treat STP as management traffic. STP traffic is designated for the CPU port
only. In addition, STP traffic has to pass blocked ports.

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index bb1a24c8078be..b488990b5b06e 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1074,6 +1074,17 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
+	static struct hellcreek_fdb_entry stp = {
+		/* MAC: 01-80-C2-00-00-00 */
+		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
 	int ret;
 
 	mutex_lock(&hellcreek->reg_lock);
@@ -1081,6 +1092,9 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	if (ret)
 		goto out;
 	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &stp);
 out:
 	mutex_unlock(&hellcreek->reg_lock);
 
-- 
2.34.1



