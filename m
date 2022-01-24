Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A7A49A331
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365004AbiAXXuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455411AbiAXVfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B05BC0BD105;
        Mon, 24 Jan 2022 12:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17EEBB8122D;
        Mon, 24 Jan 2022 20:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31565C340E5;
        Mon, 24 Jan 2022 20:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055736;
        bh=fbwYxUYlvTYPzaUQAL027dB4qyx/sJYlFcXuAvJKKXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tffNzc9B7EEdiXo9kqoSLr2Fs0DAxNmFjPoED9YjQsh+kZqt3kDFZmlYxaWacOCa4
         i4zCiRgifH8m1Te9CnAvz1vgeaDB8JrWkvao0vcsv7R+bf901d1nTGREze4vQ+vHKL
         FqyroEImBdLxfz6CXjxAtsLDpPbzcqaxF3vI5CCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/846] net: dsa: hellcreek: Add STP forwarding rule
Date:   Mon, 24 Jan 2022 19:36:05 +0100
Message-Id: <20220124184109.501854158@linuxfoundation.org>
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
index 2afd6a4f02b88..1469e41f2045a 100644
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



