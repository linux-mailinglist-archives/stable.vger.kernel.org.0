Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328FE505106
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiDRMag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbiDRM1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0351EC47;
        Mon, 18 Apr 2022 05:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58DB60EF4;
        Mon, 18 Apr 2022 12:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F34C385A7;
        Mon, 18 Apr 2022 12:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284481;
        bh=rYRFrmduGK9OPApLKSoWYm1uIg6/U0nzJAGC+goYJts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWmTlZyPd/lu4anGFFdtyBqhUjQxRSLKRA+FrVD975Mw+aOElgHPstbuUYYBVThVb
         VPTutI3+0CjdJG3Wvd4ceXz1KjdjBQFMU8Eypp7CRM+abX0oi9Qw6ea/E1QwuGRBwG
         yghdled1ZiaurCmVgvwBvDGt3gd02eXbf7GjS66A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 105/219] net: lan966x: Stop processing the MAC entry is port is wrong.
Date:   Mon, 18 Apr 2022 14:11:14 +0200
Message-Id: <20220418121209.833152383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 269219321eb7d7645a3122cf40a420c5dc655eb9 ]

Currently when getting a new MAC is learn, the HW generates an
interrupt. So then the SW will check the new entry and checks if it
arrived on a correct port. If it didn't just generate a warning.
But this could still crash the system. Therefore stop processing that
entry when an issue is seen.

Fixes: 5ccd66e01cbef8 ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index ce5970bdcc6a..2679111ef669 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -346,7 +346,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 			lan966x_mac_process_raw_entry(&raw_entries[column],
 						      mac, &vid, &dest_idx);
-			WARN_ON(dest_idx > lan966x->num_phys_ports);
+			if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+				continue;
 
 			/* If the entry in SW is found, then there is nothing
 			 * to do
@@ -392,7 +393,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 		lan966x_mac_process_raw_entry(&raw_entries[column],
 					      mac, &vid, &dest_idx);
-		WARN_ON(dest_idx > lan966x->num_phys_ports);
+		if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+			continue;
 
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
 		if (!mac_entry)
-- 
2.35.1



