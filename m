Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0353289C2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhCASEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239221AbhCAR7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4795E6505C;
        Mon,  1 Mar 2021 17:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619360;
        bh=Br+XcuD1z8JWdKLrozAG5DU3Zh+cyMeiZ336oY82VSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBL6DgLFDqtZ60NbVwpouvCwOXMVzwWasag/DFxn8DHeG++yVuq3Ld6A0/Vpc25fn
         1fFQ2jlTgLiXDcUA/w0ORxbgPKeCRplF/6V30Mglxz09AEwjvJ5XPqZRNz0MhkKeU2
         pV4ivvS7/yYHrSVPAXfzdhMgq/C1igF/kLZMNECg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/663] phy: cadence-torrent: Fix error code in cdns_torrent_phy_probe()
Date:   Mon,  1 Mar 2021 17:10:44 +0100
Message-Id: <20210301161201.459792784@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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



