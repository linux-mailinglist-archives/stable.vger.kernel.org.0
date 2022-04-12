Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478684FDAFB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbiDLHcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353637AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA9043AFF;
        Tue, 12 Apr 2022 00:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C18F60B2B;
        Tue, 12 Apr 2022 07:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F64AC385A6;
        Tue, 12 Apr 2022 07:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746959;
        bh=vr7Wo20zHLHWbtiSd/Y1L2t36ZxOiBHBQ+ROACpAYAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjW87X29xvCqlhXmL8z4SKyVVI0G6SdbTYF6tOrzboi6TyEU0ezh9WaGKX7FqKfvz
         tsQPdntymVShhDTROanvHWdr1i1hhJXa+2E/gTjL6XAjpu9l0PusPBe7RW7mjXEn6K
         IfUsDd0JJiQjn/lCgfzYrmcps4Xk12548Xw3t/F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 191/285] net: openvswitch: dont send internal clone attribute to the userspace.
Date:   Tue, 12 Apr 2022 08:30:48 +0200
Message-Id: <20220412062949.174513537@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 3f2a3050b4a3e7f32fc0ea3c9b0183090ae00522 ]

'OVS_CLONE_ATTR_EXEC' is an internal attribute that is used for
performance optimization inside the kernel.  It's added by the kernel
while parsing user-provided actions and should not be sent during the
flow dump as it's not part of the uAPI.

The issue doesn't cause any significant problems to the ovs-vswitchd
process, because reported actions are not really used in the
application lifecycle and only supposed to be shown to a human via
ovs-dpctl flow dump.  However, the action list is still incorrect
and causes the following error if the user wants to look at the
datapath flows:

  # ovs-dpctl add-dp system@ovs-system
  # ovs-dpctl add-flow "<flow match>" "clone(ct(commit),0)"
  # ovs-dpctl dump-flows
  <flow match>, packets:0, bytes:0, used:never,
    actions:clone(bad length 4, expected -1 for: action0(01 00 00 00),
                  ct(commit),0)

With the fix:

  # ovs-dpctl dump-flows
  <flow match>, packets:0, bytes:0, used:never,
    actions:clone(ct(commit),0)

Additionally fixed an incorrect attribute name in the comment.

Fixes: b233504033db ("openvswitch: kernel datapath clone action")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/20220404104150.2865736-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c      | 2 +-
 net/openvswitch/flow_netlink.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 780d9e2246f3..8955f31fa47e 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1051,7 +1051,7 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
 	int rem = nla_len(attr);
 	bool dont_clone_flow_key;
 
-	/* The first action is always 'OVS_CLONE_ATTR_ARG'. */
+	/* The first action is always 'OVS_CLONE_ATTR_EXEC'. */
 	clone_arg = nla_data(attr);
 	dont_clone_flow_key = nla_get_u32(clone_arg);
 	actions = nla_next(clone_arg, &rem);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 0d677c9c2c80..2679007f8aeb 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3429,7 +3429,9 @@ static int clone_action_to_attr(const struct nlattr *attr,
 	if (!start)
 		return -EMSGSIZE;
 
-	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
+	/* Skipping the OVS_CLONE_ATTR_EXEC that is always the first attribute. */
+	attr = nla_next(nla_data(attr), &rem);
+	err = ovs_nla_put_actions(attr, rem, skb);
 
 	if (err)
 		nla_nest_cancel(skb, start);
-- 
2.35.1



