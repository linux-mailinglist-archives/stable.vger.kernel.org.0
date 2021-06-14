Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100693A6310
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhFNLJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235270AbhFNLHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:07:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D603E6192D;
        Mon, 14 Jun 2021 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667537;
        bh=2uwaVsPK2zTkalP0xt6gnzMNcxNWQd6t3tx/lFS8+MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqB+eEjQ+8NTTg50+VfYNrS/NVHXL8atwpx5ey5J83dRIQIqSSNunzTTn5JcPG2cl
         ssqp8Ab2bIRpnFmxYemi1dD3NgnGqhMDeajYyLXG6OmePzWdU5VlQtC2axskq7wc/Q
         EgqEUaRSDiwEPgfY2oEE+v86qRcYCroD6YLOWrRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 108/131] phy: cadence: Sierra: Fix error return code in cdns_sierra_phy_probe()
Date:   Mon, 14 Jun 2021 12:27:49 +0200
Message-Id: <20210614102656.680924421@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

commit 6411e386db0a477217607015e7d2910d02f75426 upstream.

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: a43f72ae136a ("phy: cadence: Sierra: Change MAX_LANES of Sierra to 16")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Link: https://lore.kernel.org/r/20210517015749.127799-1-wangwensheng4@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -614,6 +614,7 @@ static int cdns_sierra_phy_probe(struct
 	sp->nsubnodes = node;
 
 	if (sp->num_lanes > SIERRA_MAX_LANES) {
+		ret = -EINVAL;
 		dev_err(dev, "Invalid lane configuration\n");
 		goto put_child2;
 	}


