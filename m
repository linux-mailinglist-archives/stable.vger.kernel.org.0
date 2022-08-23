Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF2059D4F1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbiHWI1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243544AbiHWIZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED0C6A4BC;
        Tue, 23 Aug 2022 01:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909C761257;
        Tue, 23 Aug 2022 08:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECCFC433D6;
        Tue, 23 Aug 2022 08:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242394;
        bh=uGThrt33mi1eSMf2gxBEVQ79aDsfgcKb82P3o+mpreY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEerS4iYBk1WCArn2tJ6CYhEYHA7fVNNcdZQxLUYa8Yg2gSET9+gOOo4Xg4/Y1Wpe
         YiLTZRSSnWPXuYxU6Fkx0cxJrIHAuGgsI2v9iPfSmnAWWymxlzrdOC+PRJka1Iif+g
         JvrTo9394MOEMyqsY7X7+YyDwLfbdzu7zrtQ2CH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 065/101] net_sched: cls_route: disallow handle of 0
Date:   Tue, 23 Aug 2022 10:03:38 +0200
Message-Id: <20220823080037.066078661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
 net/sched/cls_route.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -427,6 +427,9 @@ static int route4_set_parms(struct net *
 			goto errout;
 	}
 
+	if (!nhandle)
+		return -EINVAL;
+
 	h1 = to_hash(nhandle);
 	b = rtnl_dereference(head->table[h1]);
 	if (!b) {
@@ -486,6 +489,9 @@ static int route4_change(struct net *net
 	int err;
 	bool new = true;
 
+	if (!handle)
+		return -EINVAL;
+
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 


