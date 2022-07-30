Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870EC585AD7
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiG3OpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 10:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiG3OpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 10:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0BA62CF
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 07:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93CC460DC0
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 14:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBA0C433D6;
        Sat, 30 Jul 2022 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659192311;
        bh=4uqKB0elQRmsTO1c1R5M8oY4B3Mxe2VMkhNi4yeE+EM=;
        h=Subject:To:Cc:From:Date:From;
        b=MDRn7bOq/Vt7z2ItMBbgqDlsYh/sh+sCmhRjOXfYTipW9Z3+ChqTvQ/Y/8iS4OTKO
         j4qmZMuNPfD0OVscB/yvhk2HTELPm2QX4NNZLwdEBKppmPlLURb/kWSV7WtjmCiGPF
         iIjnHYlA7ZQgn0CnUDx6exQeaKwQholBrhBqpko4=
Subject: FAILED: patch "[PATCH] bridge: Do not send empty IFLA_AF_SPEC attribute" failed to apply to 5.15-stable tree
To:     bpoirier@nvidia.com, idosch@nvidia.com, pabeni@redhat.com,
        razor@blackwall.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jul 2022 16:45:08 +0200
Message-ID: <165919230819483@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b134b1694ec8926926ba6b7b80884ea829245a0 Mon Sep 17 00:00:00 2001
From: Benjamin Poirier <bpoirier@nvidia.com>
Date: Mon, 25 Jul 2022 09:12:36 +0900
Subject: [PATCH] bridge: Do not send empty IFLA_AF_SPEC attribute

After commit b6c02ef54913 ("bridge: Netlink interface fix."),
br_fill_ifinfo() started to send an empty IFLA_AF_SPEC attribute when a
bridge vlan dump is requested but an interface does not have any vlans
configured.

iproute2 ignores such an empty attribute since commit b262a9becbcb
("bridge: Fix output with empty vlan lists") but older iproute2 versions as
well as other utilities have their output changed by the cited kernel
commit, resulting in failed test cases. Regardless, emitting an empty
attribute is pointless and inefficient.

Avoid this change by canceling the attribute if no AF_SPEC data was added.

Fixes: b6c02ef54913 ("bridge: Netlink interface fix.")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20220725001236.95062-1-bpoirier@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bb01776d2d88..c96509c442a5 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -589,9 +589,13 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	}
 
 done:
+	if (af) {
+		if (nlmsg_get_pos(skb) - (void *)af > nla_attr_size(0))
+			nla_nest_end(skb, af);
+		else
+			nla_nest_cancel(skb, af);
+	}
 
-	if (af)
-		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
 	return 0;
 

