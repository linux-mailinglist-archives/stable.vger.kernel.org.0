Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937C2A5925
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgKCUmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgKCUmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F12223BD;
        Tue,  3 Nov 2020 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436159;
        bh=4kvcm+E6iR7HvgO6CvU7PZmFbbazBMwX9jG0X/JX16Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noxWrMohqGdk+b/GQjaTbYWcT52rc0+OwHn5iyDHWM2TwPYsBl0/BXJg4CnWJHey0
         tJOeGKPBllifEYVlkMyJSIExsVFnTL4I1wtXhGtHF8qzMWPHAX84Zei9AoylFyzv6Y
         4MbwcqfJQAexzKYdlKYDdV+Gf/A0jDWsYt1oaHf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Kardach <skardach@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 127/391] octeontx2-af: fix LD CUSTOM LTYPE aliasing
Date:   Tue,  3 Nov 2020 21:32:58 +0100
Message-Id: <20201103203355.397083883@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

[ Upstream commit 450f0b978870c384dd81d1176088536555f3170e ]

Since LD contains LTYPE definitions tweaked toward efficient
NIX_AF_RX_FLOW_KEY_ALG(0..31)_FIELD(0..4) usage, the original location
of NPC_LT_LD_CUSTOM0/1 was aliased with MPLS_IN_* definitions.
Moving custom frame to value 6 and 7 removes the aliasing at the cost of
custom frames being also considered when TCP/UDP RSS algo is configured.

However since the goal of CUSTOM frames is to classify them to a
separate set of RQs, this cost is acceptable.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3803af9231c68..c0ff5f70aa431 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -77,6 +77,8 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_ICMP,
 	NPC_LT_LD_SCTP,
 	NPC_LT_LD_ICMP6,
+	NPC_LT_LD_CUSTOM0,
+	NPC_LT_LD_CUSTOM1,
 	NPC_LT_LD_IGMP = 8,
 	NPC_LT_LD_ESP,
 	NPC_LT_LD_AH,
@@ -85,8 +87,6 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_NSH,
 	NPC_LT_LD_TU_MPLS_IN_NSH,
 	NPC_LT_LD_TU_MPLS_IN_IP,
-	NPC_LT_LD_CUSTOM0 = 0xE,
-	NPC_LT_LD_CUSTOM1 = 0xF,
 };
 
 enum npc_kpu_le_ltype {
-- 
2.27.0



