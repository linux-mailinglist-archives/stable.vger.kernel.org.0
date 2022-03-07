Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8684CF77D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiCGJqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239200AbiCGJjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB1F70CF6;
        Mon,  7 Mar 2022 01:34:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B26561185;
        Mon,  7 Mar 2022 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44621C340F3;
        Mon,  7 Mar 2022 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645636;
        bh=CpzA/lTh37mJ+O0hu79YTOCucDV/d/WNV37Yg0T0+dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNG8fRc78FrkVMjd21rZ+XaEAuOFdRXOCPGszAtMdrrLglVB5R4s3oLLaWWe7Y27w
         Gzr5W1A35u+D5e09FwB7IzIk/cwqsGQgt77SJBA2KW+WbqT6W1qtcQJIL8GzuhEHsZ
         UdZf4Fb+cRONG5PEEnOIT4XnZcDLiVKYhyybaneA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/105] net: dcb: disable softirqs in dcbnl_flush_dev()
Date:   Mon,  7 Mar 2022 10:19:37 +0100
Message-Id: <20220307091646.821776202@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

[ Upstream commit 10b6bb62ae1a49ee818fc479cf57b8900176773e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dcb/dcbnl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 799ff0efcc55..2535d3dfb92c 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2067,7 +2067,7 @@ static void dcbnl_flush_dev(struct net_device *dev)
 {
 	struct dcb_app_type *itr, *tmp;
 
-	spin_lock(&dcb_lock);
+	spin_lock_bh(&dcb_lock);
 
 	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
 		if (itr->ifindex == dev->ifindex) {
@@ -2076,7 +2076,7 @@ static void dcbnl_flush_dev(struct net_device *dev)
 		}
 	}
 
-	spin_unlock(&dcb_lock);
+	spin_unlock_bh(&dcb_lock);
 }
 
 static int dcbnl_netdevice_event(struct notifier_block *nb,
-- 
2.34.1



