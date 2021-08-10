Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5DE3E7E83
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhHJRdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhHJRd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E74D60F41;
        Tue, 10 Aug 2021 17:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616784;
        bh=y12iQn0jQuAmtCkT58rXuIsWVDtZvJLbmgfh4RI+Cyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMrvKZ71KNlNtnU7LcmKB8tn99rObhaBD8r24BU8kirUi44VrNSxiXssxAwLh1HLP
         LnZvyAHe2mncbD44a14CT5bybv9LQPDeSYG0V4awiTQPiyX0ne9/tPktmyfK0JmMxu
         mCdR6W66tzjWu+obUmBkIuYC3Xc23eom1jcCxYLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/54] nfp: update ethtool reporting of pauseframe control
Date:   Tue, 10 Aug 2021 19:30:06 +0200
Message-Id: <20210810172944.592235490@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index 9043d2cadd5d..2e75d0af4a58 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -292,6 +292,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
-- 
2.30.2



