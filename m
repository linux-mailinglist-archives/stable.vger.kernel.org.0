Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E46C4512B2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347214AbhKOTjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244952AbhKOTSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B8D634E6;
        Mon, 15 Nov 2021 18:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000774;
        bh=RVPesjfFaUpLuAjJj4MexMZO7Ju4/g9b/3mA5ZBD1+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx2n+rsutWhw9cyjqslddDXduioS0ZA1jUYg7Rsz2GOw77/4G3d5woEdhueNRzQmM
         Buu11XuGE+tP+10vHncgtyFn6ZAfcR8MtlgTcht/2Olg6BT/8Jno7ovzXmEzpoKgLw
         bs7cnEzgzxxSCFk+VTHQxAJoRC8U8mKgGFnNTDAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 779/849] net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory
Date:   Mon, 15 Nov 2021 18:04:22 +0100
Message-Id: <20211115165446.597835254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7a166854b4e24c57d56b3eba9fe1594985ee0a2c ]

It is spurious to allocate a bitmap without initializing it.
So, better safe than sorry, initialize it to 0 at least to have some known
values.

While at it, switch to the devm_bitmap_ API which is less verbose.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0c75e0576ee1f..1ef0aaef5c61c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1299,10 +1299,8 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	if (!ale)
 		return ERR_PTR(-ENOMEM);
 
-	ale->p0_untag_vid_mask =
-		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
-				   sizeof(unsigned long),
-				   GFP_KERNEL);
+	ale->p0_untag_vid_mask = devm_bitmap_zalloc(params->dev, VLAN_N_VID,
+						    GFP_KERNEL);
 	if (!ale->p0_untag_vid_mask)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.33.0



