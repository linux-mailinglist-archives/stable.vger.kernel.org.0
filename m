Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F08D5F9975
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiJJHMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiJJHLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5551F63F;
        Mon, 10 Oct 2022 00:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F222B80E28;
        Mon, 10 Oct 2022 07:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF315C433C1;
        Mon, 10 Oct 2022 07:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385618;
        bh=wWIt7W38r1172jhSxno5+FW8NgxPwz1Fi0FdN/Yqt7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjirBdYgNdTSrj+EGX0RteJ0PGFdedEwYKTMftKQ05clN0YucebRKgjiLLaPk3VEb
         SOajAWcD2uxhehCK+SUzZ/eQfUsWmN+RDNr52njNp8PLVbxuIwG1dUaW6jRrhcKEjH
         C7z2eXh3zjSfvmkuS2ZCoDimlmOfqffeoxzMwS3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Daniel Golle <daniel@makrotopia.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 46/48] net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear
Date:   Mon, 10 Oct 2022 09:05:44 +0200
Message-Id: <20221010070334.889462162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

commit ae3ed15da5889263de372ff9df2e83e16acca4cb upstream.

Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
on older MTK_NETSYS_V1 SoCs, OpenWrt users have confirmed the bug on
MT7622 and MT7621 systems.
Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.

Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).

Suggested-by: Felix Fietkau <nbd@nbd.name>
Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear")
Fixes: 33fc42de33278b ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/YzY+1Yg0FBXcnrtc@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -412,7 +412,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *pp
 	if (entry->hash != 0xffff) {
 		ppe->foe_table[entry->hash].ib1 &= ~MTK_FOE_IB1_STATE;
 		ppe->foe_table[entry->hash].ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE,
-							      MTK_FOE_STATE_UNBIND);
+							      MTK_FOE_STATE_INVALID);
 		dma_wmb();
 	}
 	entry->hash = 0xffff;


