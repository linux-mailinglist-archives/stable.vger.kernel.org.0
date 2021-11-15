Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45FC450EAD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhKOSSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240735AbhKOSNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70722633C8;
        Mon, 15 Nov 2021 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998509;
        bh=SAk3k6pYqSL05PHMMQcZe6v+WavBkegzjv16pomXAMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLAZP07yh08LZ0xHip/AfbSipFVa67uepEPJEtg/nw9FUNEvrl3U+6L41tBp8Tqcj
         0PydKIH0Y3jFCIj87oDu4U4zvPCLCGHMdajzPPQ6a/uPbfRPojR92oA45HdV/oBS8t
         3UEHOCYHe8toWE5mSka7VCk2fweekhSi86nYp6uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 534/575] net: stmmac: allow a tc-taprio base-time of zero
Date:   Mon, 15 Nov 2021 18:04:19 +0100
Message-Id: <20211115165402.136596353@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f64ab8e4f368f48afb08ae91928e103d17b235e9 ]

Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
base_time is in the past") allowed some base time values in the past,
but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
explicitly denied by the driver.

Remove the bogus check.

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6399803061158..43165c662740d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -679,8 +679,6 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		goto disable;
 	if (qopt->num_entries >= dep)
 		return -EINVAL;
-	if (!qopt->base_time)
-		return -ERANGE;
 	if (!qopt->cycle_time)
 		return -ERANGE;
 
-- 
2.33.0



