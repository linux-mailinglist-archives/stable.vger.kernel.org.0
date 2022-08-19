Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB38599E78
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350067AbiHSPma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349721AbiHSPlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56841101D20;
        Fri, 19 Aug 2022 08:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749D3615FC;
        Fri, 19 Aug 2022 15:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDA5C433C1;
        Fri, 19 Aug 2022 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923667;
        bh=QXKbbD2rBMM2SVJ7jtAh4BSriiVTIwVcRFRHymGJ04g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHa2v3hybS9+H/eLQFowKQJiHAJ/hkS8sxY6jZoazvF5vtxWVSm6K2QQPGIzwy7uk
         4kfCQF8wwIrcyy1VYAaUtOVH7yrNAzRPQS0hgeg25vQ0AxjgAN3CYtkE8qykJm0Mpi
         6rC1aGgRTnslyPTMOT9xR4PnGMY8veAbwwEwnZ4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 03/14] net_sched: cls_route: disallow handle of 0
Date:   Fri, 19 Aug 2022 17:40:19 +0200
Message-Id: <20220819153711.787764500@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
References: <20220819153711.658766010@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 02799571714dc5dd6948824b9d080b44a295f695 upstream.

Follows up on:
https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/

handle of 0 implies from/to of universe realm which is not very
sensible.

Lets see what this patch will do:
$sudo tc qdisc add dev $DEV root handle 1:0 prio

//lets manufacture a way to insert handle of 0
$sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 \
route to 0 from 0 classid 1:10 action ok

//gets rejected...
Error: handle of 0 is not valid.
We have an error talking to the kernel, -1

//lets create a legit entry..
sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 route from 10 \
classid 1:10 action ok

//what did the kernel insert?
$sudo tc filter ls dev $DEV parent 1:0
filter protocol ip pref 100 route chain 0
filter protocol ip pref 100 route chain 0 fh 0x000a8000 flowid 1:10 from 10
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

//Lets try to replace that legit entry with a handle of 0
$ sudo tc filter replace dev $DEV parent 1:0 protocol ip prio 100 \
handle 0x000a8000 route to 0 from 0 classid 1:10 action drop

Error: Replacing with handle of 0 is invalid.
We have an error talking to the kernel, -1

And last, lets run Cascardo's POC:
$ ./poc
0
0
-22
-22
-22

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_route.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -424,6 +424,11 @@ static int route4_set_parms(struct net *
 			return -EINVAL;
 	}
 
+	if (!nhandle) {
+		NL_SET_ERR_MSG(extack, "Replacing with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	h1 = to_hash(nhandle);
 	b = rtnl_dereference(head->table[h1]);
 	if (!b) {
@@ -477,6 +482,11 @@ static int route4_change(struct net *net
 	int err;
 	bool new = true;
 
+	if (!handle) {
+		NL_SET_ERR_MSG(extack, "Creating with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 


