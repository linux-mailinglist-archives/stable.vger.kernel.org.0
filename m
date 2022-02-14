Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893FB4B460E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbiBNJcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243533AbiBNJcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA941AD9F;
        Mon, 14 Feb 2022 01:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D2160F8D;
        Mon, 14 Feb 2022 09:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98830C340F2;
        Mon, 14 Feb 2022 09:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831038;
        bh=l0212FSHtUxE+34kUIAZLJhq/HpoQd/R+RJu5Jxqgx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM786ksiRBjsaKxlLQvQ9A9ukZRnc6OJRTgK2DM9WZE+sy3caz813ozoXpGSYeRX0
         x/XNqgbDVBw4wyEW3m2s3L42angpeo55sW1kTt5YfeAyY+GQncyizdEMz/I7m25uoH
         uFOTsrBnWb/Mmsi3YQyhpzeMrOelOiduKqZdQ8cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/44] bonding: pair enable_port with slave_arr_updates
Date:   Mon, 14 Feb 2022 10:25:46 +0100
Message-Id: <20220214092448.662740295@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit 23de0d7b6f0e3f9a6283a882594c479949da1120 ]

When 803.2ad mode enables a participating port, it should update
the slave-array. I have observed that the member links are participating
and are part of the active aggregator while the traffic is egressing via
only one member link (in a case where two links are participating). Via
kprobes I discovered that slave-arr has only one link added while
the other participating link wasn't part of the slave-arr.

I couldn't see what caused that situation but the simple code-walk
through provided me hints that the enable_port wasn't always associated
with the slave-array update.

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20220207222901.1795287-1-maheshb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 93dfcef8afc4b..035923876c617 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1012,8 +1012,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1760,6 +1760,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			*update_slave_arr = true;
 		}
 	}
 
-- 
2.34.1



