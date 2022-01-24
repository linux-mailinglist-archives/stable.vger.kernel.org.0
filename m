Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE0C4992BB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345796AbiAXUYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:24:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355702AbiAXUWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133DBB811F9;
        Mon, 24 Jan 2022 20:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492FDC340E5;
        Mon, 24 Jan 2022 20:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055733;
        bh=WuhYVlVH6hrjU6oz3Z+NaALUBIDERrBjbaDwmauXbdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mawaqr07xcI5LaBgxiRYFrtefp+/9UKO5nVy2gLy6tgQUrVe7h6AZr74KouPujQvJ
         c/NX/zYpPNK7sT7KD7cFbnED+roi+RKw+dlA4kXY5meNGAF24IBndaf8/qpf+kGJnd
         LyDG3D5UHd2cEBOViFbqe3gZaaQYWslHqW5h07hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/846] net: dsa: hellcreek: Fix insertion of static FDB entries
Date:   Mon, 24 Jan 2022 19:36:04 +0100
Message-Id: <20220124184109.470704169@linuxfoundation.org>
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

[ Upstream commit 4db4c3ea56978086ca367a355e440de17d534827 ]

The insertion of static FDB entries ignores the pass_blocked bit. That bit is
evaluated with regards to STP. Add the missing functionality.

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 354655f9ed003..2afd6a4f02b88 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -710,8 +710,9 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	u16 meta = 0;
 
 	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
-		"OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
-		entry->is_obt, entry->reprio_en, entry->reprio_tc);
+		"OBT=%d, PASS_BLOCKED=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac,
+		entry->portmask, entry->is_obt, entry->pass_blocked,
+		entry->reprio_en, entry->reprio_tc);
 
 	/* Add mac address */
 	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
@@ -722,6 +723,8 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
 	if (entry->is_obt)
 		meta |= HR_FDBWRM0_OBT;
+	if (entry->pass_blocked)
+		meta |= HR_FDBWRM0_PASS_BLOCKED;
 	if (entry->reprio_en) {
 		meta |= HR_FDBWRM0_REPRIO_EN;
 		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
-- 
2.34.1



