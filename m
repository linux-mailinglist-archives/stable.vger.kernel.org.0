Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6381E34CA76
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhC2Iil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234388AbhC2Ig7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B7D619A0;
        Mon, 29 Mar 2021 08:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006973;
        bh=YnhR0fW0rO5W1niRWWE47ZOFiFU2dHcUJfrdNzIeCBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxA208s3AaygIs/2WhyaGz5i8sRCAcC77q+scxh7T3ckExaRS4bdQ/uvehCGZhdV1
         Pw5f2zL4CymMvONT73Q0zuavcSoqHL2/wvbxWpHJ5NSgLty1AkjlxjU3JvPJJTW971
         mXmXTIp7ToLaGm2TvKPrn3fhW7/DV2pQZr+TAdKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 174/254] octeontx2-af: Remove TOS field from MKEX TX
Date:   Mon, 29 Mar 2021 09:58:10 +0200
Message-Id: <20210329075638.878782160@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit ce86c2a531e2f2995ee55ea527c1f39ba1d95f73 ]

The MKEX profile describes what packet fields need to be extracted from
the input packet and how to place those packet fields in the output key
for MCAM matching.  The MKEX profile can be in a way where higher layer
packet fields can overwrite lower layer packet fields in output MCAM
Key.
Hence MKEX profile is always ensured that there are no overlaps between
any of the layers. But the commit 42006910b5ea
("octeontx2-af: cleanup KPU config data") introduced TX TOS field which
overlaps with DMAC in MCAM key.
This led to AF driver returning error when TX rule is installed with
DMAC as match criteria since DMAC gets overwritten and cannot be
supported. This patch fixes the issue by removing TOS field from MKEX TX
profile.

Fixes: 42006910b5ea ("octeontx2-af: cleanup KPU config data")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index b192692b4fc4..5c372d2c24a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13499,8 +13499,6 @@ static struct npc_mcam_kex npc_mkex_default = {
 			[NPC_LT_LC_IP] = {
 				/* SIP+DIP: 8 bytes, KW2[63:0] */
 				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
-				/* TOS: 1 byte, KW1[63:56] */
-				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
 			},
 			/* Layer C: IPv6 */
 			[NPC_LT_LC_IP6] = {
-- 
2.30.1



