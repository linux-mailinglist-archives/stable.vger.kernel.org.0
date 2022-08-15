Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E62594006
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiHOVIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243106AbiHOVFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A60151A0E;
        Mon, 15 Aug 2022 12:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF685B810C6;
        Mon, 15 Aug 2022 19:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28F3C433D6;
        Mon, 15 Aug 2022 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590892;
        bh=BAEcyU3+ShsFXc6JgX0vieoDWdx4El55H+ZjK+qyTOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re7yNE4C08PXBfdXIWgdFu42FiukIZwkCP7Qv89qsmenzteUFtxAe9PPl98NWTNyo
         MvWOEn9MVtWDr8FHRsriSf6Eu7Dc3aMjoxGPYaBSx+fgLC2v2IjPE0psqRmRPsv7vP
         cJVBLb3L+MxZOcTp1OhuaJK5GQqG//r6TixLq62o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0405/1095] net: mscc: ocelot: minimize holes in struct ocelot_port
Date:   Mon, 15 Aug 2022 19:56:44 +0200
Message-Id: <20220815180446.469088623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6d0be600477089026c76fe529bd96fad4cf69c3b ]

Reorder members of struct ocelot_port to eliminate holes and reduce
structure size. Pahole says:

Before:

struct ocelot_port {
        struct ocelot *            ocelot;               /*     0     8 */
        struct regmap *            target;               /*     8     8 */
        bool                       vlan_aware;           /*    16     1 */

        /* XXX 7 bytes hole, try to pack */

        const struct ocelot_bridge_vlan  * pvid_vlan;    /*    24     8 */
        unsigned int               ptp_skbs_in_flight;   /*    32     4 */
        u8                         ptp_cmd;              /*    36     1 */

        /* XXX 3 bytes hole, try to pack */

        struct sk_buff_head        tx_skbs;              /*    40    96 */
        /* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
        u8                         ts_id;                /*   136     1 */

        /* XXX 3 bytes hole, try to pack */

        phy_interface_t            phy_mode;             /*   140     4 */
        bool                       is_dsa_8021q_cpu;     /*   144     1 */
        bool                       learn_ena;            /*   145     1 */

        /* XXX 6 bytes hole, try to pack */

        struct net_device *        bond;                 /*   152     8 */
        bool                       lag_tx_active;        /*   160     1 */

        /* XXX 1 byte hole, try to pack */

        u16                        mrp_ring_id;          /*   162     2 */

        /* XXX 4 bytes hole, try to pack */

        struct net_device *        bridge;               /*   168     8 */
        int                        bridge_num;           /*   176     4 */
        u8                         stp_state;            /*   180     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        speed;                /*   184     4 */

        /* size: 192, cachelines: 3, members: 18 */
        /* sum members: 161, holes: 7, sum holes: 27 */
        /* padding: 4 */
};

After:

struct ocelot_port {
        struct ocelot *            ocelot;               /*     0     8 */
        struct regmap *            target;               /*     8     8 */
        struct net_device *        bond;                 /*    16     8 */
        struct net_device *        bridge;               /*    24     8 */
        const struct ocelot_bridge_vlan  * pvid_vlan;    /*    32     8 */
        phy_interface_t            phy_mode;             /*    40     4 */
        unsigned int               ptp_skbs_in_flight;   /*    44     4 */
        struct sk_buff_head        tx_skbs;              /*    48    96 */
        /* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
        u16                        mrp_ring_id;          /*   144     2 */
        u8                         ptp_cmd;              /*   146     1 */
        u8                         ts_id;                /*   147     1 */
        u8                         stp_state;            /*   148     1 */
        bool                       vlan_aware;           /*   149     1 */
        bool                       is_dsa_8021q_cpu;     /*   150     1 */
        bool                       learn_ena;            /*   151     1 */
        bool                       lag_tx_active;        /*   152     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        bridge_num;           /*   156     4 */
        int                        speed;                /*   160     4 */

        /* size: 168, cachelines: 3, members: 18 */
        /* sum members: 161, holes: 1, sum holes: 3 */
        /* padding: 4 */
        /* last cacheline: 40 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/soc/mscc/ocelot.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b191f0a7fe26..bae2ddb06731 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -652,28 +652,30 @@ struct ocelot_port {
 
 	struct regmap			*target;
 
-	bool				vlan_aware;
+	struct net_device		*bond;
+	struct net_device		*bridge;
+
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	phy_interface_t			phy_mode;
+
 	unsigned int			ptp_skbs_in_flight;
-	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
-	u8				ts_id;
 
-	phy_interface_t			phy_mode;
+	u16				mrp_ring_id;
 
+	u8				ptp_cmd;
+	u8				ts_id;
+
+	u8				stp_state;
+	bool				vlan_aware;
 	bool				is_dsa_8021q_cpu;
 	bool				learn_ena;
 
-	struct net_device		*bond;
 	bool				lag_tx_active;
 
-	u16				mrp_ring_id;
-
-	struct net_device		*bridge;
 	int				bridge_num;
-	u8				stp_state;
 
 	int				speed;
 };
-- 
2.35.1



