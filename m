Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1354566B51
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiGEMFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiGEMEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:04:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5244B1098;
        Tue,  5 Jul 2022 05:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B1D6B817D4;
        Tue,  5 Jul 2022 12:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718EAC341CB;
        Tue,  5 Jul 2022 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022667;
        bh=To1+g38CwvXFP8X3zKMmvdouclQwnDTBYBTkdXMr64o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/D2JNPTTkfKrk0iOS+Z8UJbIwliN2HW7ORABQFqryXNf1w/sXYUxCDqhhnrRkw0w
         NOuhxWwXHU644y0pkg3FJUWjqXqplDzTgGbPtkQbGNp0K4OkHDlji5dEAxM9ZexseC
         YNdu1ptsxL0ftXGN/wrsGov392sqxAjaKAlSGY3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 25/58] net: bonding: fix use-after-free after 802.3ad slave unbind
Date:   Tue,  5 Jul 2022 13:58:01 +0200
Message-Id: <20220705115610.989949975@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevhen Orlov <yevhen.orlov@plvision.eu>

commit 050133e1aa2cb49bb17be847d48a4431598ef562 upstream.

commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection"),
resolve case, when there is several aggregation groups in the same bond.
bond_3ad_unbind_slave will invalidate (clear) aggregator when
__agg_active_ports return zero. So, ad_clear_agg can be executed even, when
num_of_ports!=0. Than bond_3ad_unbind_slave can be executed again for,
previously cleared aggregator. NOTE: at this time bond_3ad_unbind_slave
will not update slave ports list, because lag_ports==NULL. So, here we
got slave ports, pointing to freed aggregator memory.

Fix with checking actual number of ports in group (as was before
commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection") ),
before ad_clear_agg().

The KASAN logs are as follows:

[  767.617392] ==================================================================
[  767.630776] BUG: KASAN: use-after-free in bond_3ad_state_machine_handler+0x13dc/0x1470
[  767.638764] Read of size 2 at addr ffff00011ba9d430 by task kworker/u8:7/767
[  767.647361] CPU: 3 PID: 767 Comm: kworker/u8:7 Tainted: G           O 5.15.11 #15
[  767.655329] Hardware name: DNI AmazonGo1 A7040 board (DT)
[  767.660760] Workqueue: lacp_1 bond_3ad_state_machine_handler
[  767.666468] Call trace:
[  767.668930]  dump_backtrace+0x0/0x2d0
[  767.672625]  show_stack+0x24/0x30
[  767.675965]  dump_stack_lvl+0x68/0x84
[  767.679659]  print_address_description.constprop.0+0x74/0x2b8
[  767.685451]  kasan_report+0x1f0/0x260
[  767.689148]  __asan_load2+0x94/0xd0
[  767.692667]  bond_3ad_state_machine_handler+0x13dc/0x1470

Fixes: 0622cab0341c ("bonding: fix 802.3ad aggregator reselection")
Co-developed-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20220629012914.361-1-yevhen.orlov@plvision.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_3ad.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2218,7 +2218,8 @@ void bond_3ad_unbind_slave(struct slave
 				temp_aggregator->num_of_ports--;
 				if (__agg_active_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
-					ad_clear_agg(temp_aggregator);
+					if (temp_aggregator->num_of_ports == 0)
+						ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */


