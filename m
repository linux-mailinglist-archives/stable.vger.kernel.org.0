Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C5A4CF5AA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiCGJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbiCGJ2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE8A6B0BF;
        Mon,  7 Mar 2022 01:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D3B261150;
        Mon,  7 Mar 2022 09:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B48BC340F6;
        Mon,  7 Mar 2022 09:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645142;
        bh=ZNdsitM6nGFjpVv13+1bhRl7U8W/yDXt/WgufaQwueA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBCdx0Y1bRVOxA1fdfl4tTjjrVSHyVs2PXHt+h2tqUSp3tO2dTJy80ydl1I/egVhK
         iJUAeZmCNrnGDyQriolralgeTWAwwFOGenaRVTp79NpbMbxrkvqjGiXIIePYwymBam
         XbSievAPizF5zW2zuAOjTqvsPJeh6r/edKPestPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 51/51] net: dcb: disable softirqs in dcbnl_flush_dev()
Date:   Mon,  7 Mar 2022 10:19:26 +0100
Message-Id: <20220307091638.441349892@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
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
@@ -2058,7 +2058,7 @@ static void dcbnl_flush_dev(struct net_d
 {
 	struct dcb_app_type *itr, *tmp;
 
-	spin_lock(&dcb_lock);
+	spin_lock_bh(&dcb_lock);
 
 	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
 		if (itr->ifindex == dev->ifindex) {
@@ -2067,7 +2067,7 @@ static void dcbnl_flush_dev(struct net_d
 		}
 	}
 
-	spin_unlock(&dcb_lock);
+	spin_unlock_bh(&dcb_lock);
 }
 
 static int dcbnl_netdevice_event(struct notifier_block *nb,


