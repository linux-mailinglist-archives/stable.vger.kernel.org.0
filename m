Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD96469BAB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356345AbhLFPSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357994AbhLFPQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D180C08EC0A;
        Mon,  6 Dec 2021 07:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF2786132B;
        Mon,  6 Dec 2021 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36E9C341C5;
        Mon,  6 Dec 2021 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803331;
        bh=Yibu21T4UbpkU3YOXbQDC588MDn3gZHuhxgP5kuPwHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFUX8h7trOjTor+QdFYLc5JiwqR26/xOn6ERqvasAHAbyQCeTZU+a8Nhu8yIG10eu
         VYbYQWCiH9HKWQslfSyvuOR0WgIsNsdfX0+nTsYrD/1Jl/MOLP6ltiRkJczH+SpXuJ
         9oJWJ0mo3PTLlSMFym95nUIYZNnyiRRWOvwTTjHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Teng Qi <starmiku1207184332@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 079/106] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Mon,  6 Dec 2021 15:56:27 +0100
Message-Id: <20211206145558.221643930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Teng Qi <starmiku1207184332@gmail.com>

[ Upstream commit a66998e0fbf213d47d02813b9679426129d0d114 ]

The if statement:
  if (port >= DSAF_GE_NUM)
        return;

limits the value of port less than DSAF_GE_NUM (i.e., 8).
However, if the value of port is 6 or 7, an array overflow could occur:
  port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;

because the length of dsaf_dev->mac_cb is DSAF_MAX_PORT_NUM (i.e., 6).

To fix this possible array overflow, we first check port and if it is
greater than or equal to DSAF_MAX_PORT_NUM, the function returns.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 408b63faf9a81..c4e56784ed1b8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -336,6 +336,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
 		return;
 
 	if (!HNS_DSAF_IS_DEBUG(dsaf_dev)) {
+		/* DSAF_MAX_PORT_NUM is 6, but DSAF_GE_NUM is 8.
+		   We need check to prevent array overflow */
+		if (port >= DSAF_MAX_PORT_NUM)
+			return;
 		reg_val_1  = 0x1 << port;
 		port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
 		/* there is difference between V1 and V2 in register.*/
-- 
2.33.0



