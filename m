Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48FA409286
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbhIMOMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345151AbhIMOJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:09:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 200F561AA3;
        Mon, 13 Sep 2021 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540501;
        bh=pm4GwbJPciCvSVen8Y+dGhc9HzrzG+1Sx6DjZ19gawk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOIMWPjTJbI8w12Vy1J34vtNhQ6Nz/UHu9WceAiTWnoy3F9/6+34ToIOENdD3ue+d
         DTJYIpYVI3cT2LacqPA+RvifIP39E9U97R8eDPydth4usssrnIFhyVgLIwcAwPc5R0
         M5aIQlSKALTvzBORgrDshnRodpw9kj7gLGE2DnAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 219/300] octeontx2-pf: send correct vlan priority mask to npc_install_flow_req
Date:   Mon, 13 Sep 2021 15:14:40 +0200
Message-Id: <20210913131116.762831403@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

[ Upstream commit 10df5a13ac6785b409ad749c4b10d4b220cc7e71 ]

This patch corrects the erroneous vlan priority mask field that was
send to npc_install_flow_req.

Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 51157b283f6f..463d2368c118 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -385,8 +385,8 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic,
 				   match.key->vlan_priority << 13;
 
 			vlan_tci_mask = match.mask->vlan_id |
-					match.key->vlan_dei << 12 |
-					match.key->vlan_priority << 13;
+					match.mask->vlan_dei << 12 |
+					match.mask->vlan_priority << 13;
 
 			flow_spec->vlan_tci = htons(vlan_tci);
 			flow_mask->vlan_tci = htons(vlan_tci_mask);
-- 
2.30.2



