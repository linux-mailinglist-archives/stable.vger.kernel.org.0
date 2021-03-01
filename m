Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294E6329072
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242919AbhCAUIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242270AbhCAT5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B80165382;
        Mon,  1 Mar 2021 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621338;
        bh=Br+XcuD1z8JWdKLrozAG5DU3Zh+cyMeiZ336oY82VSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohq8H6ojQ31ZcAdJzmW53o6+sTMOAh8EgxY1kJWnhSgqWIy5vtso34NH0WDddbH+K
         w1QMngW7iBNli71og2AMp+ytyZR6A50mKXvDeyA/D390Tb69aPXxWhiz2tb6BnO4Q0
         9FIfMAUHAlwtTfTzn4Xq00GhxOtf0Qc23XKl5Hmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 480/775] phy: cadence-torrent: Fix error code in cdns_torrent_phy_probe()
Date:   Mon,  1 Mar 2021 17:10:48 +0100
Message-Id: <20210301161225.252629306@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 266df28f9ac16b0dff553d78bc3fb1c084b96b9d ]

This error path should return -EINVAL, but currently it returns
success.

Fixes: d09945eacad0 ("phy: cadence-torrent: Check total lane count for all subnodes is within limit")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X9s7Wxq+b6ls0q7o@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-torrent.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/cadence/phy-cadence-torrent.c b/drivers/phy/cadence/phy-cadence-torrent.c
index f310e15d94cbc..591a15834b48f 100644
--- a/drivers/phy/cadence/phy-cadence-torrent.c
+++ b/drivers/phy/cadence/phy-cadence-torrent.c
@@ -2298,6 +2298,7 @@ static int cdns_torrent_phy_probe(struct platform_device *pdev)
 
 	if (total_num_lanes > MAX_NUM_LANES) {
 		dev_err(dev, "Invalid lane configuration\n");
+		ret = -EINVAL;
 		goto put_lnk_rst;
 	}
 
-- 
2.27.0



