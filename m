Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF519681033
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbjA3OBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbjA3OBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7963B3F2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA47BB8114D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C70C433D2;
        Mon, 30 Jan 2023 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087235;
        bh=C7GgloiIFQmAR6+aRZZITATpNSeQgm91hCd/foFrF+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpapfS7S616O+vsSTGxMCxO0VFVJ8w1GP58LWrPcLrebUT05Gy/aFhyTsumQJ88mx
         X6hCck5ChfIdyQ09yyNjmoFpBsRJl4qafD9UgEmHP+Yp5hLyfMuskTlJ0/WfGetpYY
         iyY2wJUre6NKVkrFXzX4uZ2Q7ievUO0S+D3H+eGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/313] net: dsa: microchip: ksz9477: port map correction in ALU table entry register
Date:   Mon, 30 Jan 2023 14:49:29 +0100
Message-Id: <20230130134342.897581515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>

[ Upstream commit 6c977c5c2e4c5d8ad1b604724cc344e38f96fe9b ]

ALU table entry 2 register in KSZ9477 have bit positions reserved for
forwarding port map. This field is referred in ksz9477_fdb_del() for
clearing forward port map and alu table.

But current fdb_del refer ALU table entry 3 register for accessing forward
port map. Update ksz9477_fdb_del() to get forward port map from correct
alu table entry register.

With this bug, issue can be observed while deleting static MAC entries.
Delete any specific MAC entry using "bridge fdb del" command. This should
clear all the specified MAC entries. But it is observed that entries with
self static alone are retained.

Tested on LAN9370 EVB since ksz9477_fdb_del() is used common across
LAN937x and KSZ series.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20230118174735.702377-1-rakesh.sankaranarayanan@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a6a0321a8931..a73697147053 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -548,10 +548,10 @@ int ksz9477_fdb_del(struct ksz_device *dev, int port,
 		ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
 
 		/* clear forwarding port */
-		alu_table[2] &= ~BIT(port);
+		alu_table[1] &= ~BIT(port);
 
 		/* if there is no port to forward, clear table */
-		if ((alu_table[2] & ALU_V_PORT_MAP) == 0) {
+		if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
 			alu_table[0] = 0;
 			alu_table[1] = 0;
 			alu_table[2] = 0;
-- 
2.39.0



