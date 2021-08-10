Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4403E7EDC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhHJRfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhHJRes (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EEAB6109E;
        Tue, 10 Aug 2021 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616865;
        bh=kHC0BEt7uSPi7mzIZRmtyXHWQk8ug+KOaKNi/Q7JPqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yemaSyDwOx+fVk/jXvikfOkP6UQMCWze5B6V2rdt+CWy5WSxNiq9pMn03aqc7aCCU
         +pArxG55lugCJ2WhvGs+Z5qn4CQQrZmS9ML4hQWJW8E1Pau7U/GNFUrkNLbvUGjfAr
         1NTB6Aplm12GYNkTjtfNomnqfDrU3FJh5G/ix530=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/85] nfp: update ethtool reporting of pauseframe control
Date:   Tue, 10 Aug 2021 19:30:00 +0200
Message-Id: <20210810172949.113738512@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

[ Upstream commit 9fdc5d85a8fe684cdf24dc31c6bc4a727decfe87 ]

Pauseframe control is set to symmetric mode by default on the NFP.
Pause frames can not be configured through ethtool now, but ethtool can
report the supported mode.

Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 17b91ed39369..2354dec99418 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -266,6 +266,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
-- 
2.30.2



