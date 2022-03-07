Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50A4CF4D3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiCGJWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiCGJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:22:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9520A6662A;
        Mon,  7 Mar 2022 01:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45507B81054;
        Mon,  7 Mar 2022 09:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730FBC340E9;
        Mon,  7 Mar 2022 09:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644828;
        bh=tohyZRhddFOBEy3gO5lm9g2AbMMXdntkNRSQfG7NnjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdIEpxWQvbf0i5E56MqkCPIx9lVSZYExpxQ/S9oVeLjnnX6bgEESLPOO9jCzzb/rk
         QHVsTBqGzj7ZsLbypMPYCFPkREkNYOLNLLoptw1Qk5ynSYLVtuw814JFBMjyEpuvRs
         rChmU8V3VyQcN7p6hyaDt4R3Ik+WNveV5+/ptn5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 32/32] net: dcb: disable softirqs in dcbnl_flush_dev()
Date:   Mon,  7 Mar 2022 10:18:58 +0100
Message-Id: <20220307091635.351396827@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 10b6bb62ae1a49ee818fc479cf57b8900176773e upstream.

Ido Schimmel points out that since commit 52cff74eef5d ("dcbnl : Disable
software interrupts before taking dcb_lock"), the DCB API can be called
by drivers from softirq context.

One such in-tree example is the chelsio cxgb4 driver:
dcb_rpl
-> cxgb4_dcb_handle_fw_update
   -> dcb_ieee_setapp

If the firmware for this driver happened to send an event which resulted
in a call to dcb_ieee_setapp() at the exact same time as another
DCB-enabled interface was unregistering on the same CPU, the softirq
would deadlock, because the interrupted process was already holding the
dcb_lock in dcbnl_flush_dev().

Fix this unlikely event by using spin_lock_bh() in dcbnl_flush_dev() as
in the rest of the dcbnl code.

Fixes: 91b0383fef06 ("net: dcb: flush lingering app table entries for unregistered devices")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220302193939.1368823-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1942,7 +1942,7 @@ static void dcbnl_flush_dev(struct net_d
 {
 	struct dcb_app_type *itr, *tmp;
 
-	spin_lock(&dcb_lock);
+	spin_lock_bh(&dcb_lock);
 
 	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
 		if (itr->ifindex == dev->ifindex) {
@@ -1951,7 +1951,7 @@ static void dcbnl_flush_dev(struct net_d
 		}
 	}
 
-	spin_unlock(&dcb_lock);
+	spin_unlock_bh(&dcb_lock);
 }
 
 static int dcbnl_netdevice_event(struct notifier_block *nb,


