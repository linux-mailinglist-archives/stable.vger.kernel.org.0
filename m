Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0303566BDD
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiGEMKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiGEMIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5262AA;
        Tue,  5 Jul 2022 05:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C227061876;
        Tue,  5 Jul 2022 12:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E7C341CB;
        Tue,  5 Jul 2022 12:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022899;
        bh=pfMuOW8Pwusuy24tjcGzgjQJszv8oTwikZnbkn9t2qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeQyBKxn9Gjf2Lo+lcyn5GZbSw3L5eT3X0GMesT+P+HUprnZFCInwan5fqYEdJaOx
         LE2ogW9UUYM7Szp/x1ItEO/nE5IWaXwtBibwJQ0oNokLrYw51hCXMMQMSBAt95tG2/
         T6GYpItKFGQRh1L0yi+874qSX4VwKFDAnHARQMsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 33/84] net: bonding: fix use-after-free after 802.3ad slave unbind
Date:   Tue,  5 Jul 2022 13:57:56 +0200
Message-Id: <20220705115616.290033643@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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
@@ -2209,7 +2209,8 @@ void bond_3ad_unbind_slave(struct slave
 				temp_aggregator->num_of_ports--;
 				if (__agg_active_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
-					ad_clear_agg(temp_aggregator);
+					if (temp_aggregator->num_of_ports == 0)
+						ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */


