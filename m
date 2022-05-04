Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5128E51A98D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356572AbiEDRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356437AbiEDRNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09F54B874;
        Wed,  4 May 2022 09:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813C661808;
        Wed,  4 May 2022 16:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9919C385AA;
        Wed,  4 May 2022 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683468;
        bh=f1LFHvJ8uk8SHhwLGhNDYMjw5ZoMM0XJ+6vYeOX3FRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojVD+tbwY8MjARWZ4ZOmv8YGxqPIYAkFg4Z3n9L/SNNJzvsD2ILkUNO9AmC/WlslO
         3iTpdmXsaJcKWtPf9KJ4HV2dvz5tQMDoSRirwpmEam7ghb8yRht2MFu7mbMuosX6Tl
         mzFzY2LnxIp5LYfU9Z6B9dmZtawvG4SBSeWQqILI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 120/225] net: lan966x: fix a couple off by one bugs
Date:   Wed,  4 May 2022 18:45:58 +0200
Message-Id: <20220504153121.194923229@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9810c58c7051ae83e7ac326fca3daa823da6b778 ]

The lan966x->ports[] array has lan966x->num_phys_ports elements.  These
are assigned in lan966x_probe().  That means the > comparison should be
changed to >=.

The first off by one check is harmless but the second one could lead to
an out of bounds access and a crash.

Fixes: 5ccd66e01cbe ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 2679111ef669..005e56ea5da1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -346,7 +346,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 			lan966x_mac_process_raw_entry(&raw_entries[column],
 						      mac, &vid, &dest_idx);
-			if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+			if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 				continue;
 
 			/* If the entry in SW is found, then there is nothing
@@ -393,7 +393,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 		lan966x_mac_process_raw_entry(&raw_entries[column],
 					      mac, &vid, &dest_idx);
-		if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 			continue;
 
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
-- 
2.35.1



