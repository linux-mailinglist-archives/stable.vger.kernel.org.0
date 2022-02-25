Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E4C4C48EC
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiBYPav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbiBYPau (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:30:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4762177D7
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD0AB830AA
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38D7C340F0;
        Fri, 25 Feb 2022 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645803015;
        bh=gjysVgjbWkO9sKjDszKJFL9XXFkxMqdNjLTa41My0z0=;
        h=Subject:To:Cc:From:Date:From;
        b=C6+nB5Muy6QpFR0QbMSboW7qBQ/SKevac3/jmqpFOv1SBJzyTEy2xL8fKjCIJjHTi
         JDnKoOME/qoNg+W/PzHqNzIhPdE1QZmDkbLTy3l5cow3Uc6+9JVTbdM3QmbpcQCWz+
         h8RsagrvYuOBbkNe9C6adVstnCjBX1wFTzvzxR0k=
Subject: FAILED: patch "[PATCH] tipc: Fix end of loop tests for list_for_each_entry()" failed to apply to 4.9-stable tree
To:     dan.carpenter@oracle.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:30:12 +0100
Message-ID: <16458030121751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a1f8fec4dac8bc7b172b2bdbd881e015261a6322 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 22 Feb 2022 16:43:12 +0300
Subject: [PATCH] tipc: Fix end of loop tests for list_for_each_entry()

These tests are supposed to check if the loop exited via a break or not.
However the tests are wrong because if we did not exit via a break then
"p" is not a valid pointer.  In that case, it's the equivalent of
"if (*(u32 *)sr == *last_key) {".  That's going to work most of the time,
but there is a potential for those to be equal.

Fixes: 1593123a6a49 ("tipc: add name table dump to new netlink api")
Fixes: 1a1a143daf84 ("tipc: add publication dump to new netlink api")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 01396dd1c899..1d8ba233d047 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -967,7 +967,7 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 		list_for_each_entry(p, &sr->all_publ, all_publ)
 			if (p->key == *last_key)
 				break;
-		if (p->key != *last_key)
+		if (list_entry_is_head(p, &sr->all_publ, all_publ))
 			return -EPIPE;
 	} else {
 		p = list_first_entry(&sr->all_publ,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 3e63c83e641c..7545321c3440 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3749,7 +3749,7 @@ static int __tipc_nl_list_sk_publ(struct sk_buff *skb,
 			if (p->key == *last_publ)
 				break;
 		}
-		if (p->key != *last_publ) {
+		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
 			/* We never set seq or call nl_dump_check_consistent()
 			 * this means that setting prev_seq here will cause the
 			 * consistence check to fail in the netlink callback

