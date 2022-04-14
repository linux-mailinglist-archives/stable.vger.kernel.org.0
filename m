Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A044501227
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbiDNOHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347670AbiDNN70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E42D47AE0;
        Thu, 14 Apr 2022 06:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65DB5B82968;
        Thu, 14 Apr 2022 13:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16A1C385A1;
        Thu, 14 Apr 2022 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944263;
        bh=AhAKy5axmBXACV88/1gcrmRV0hMa5yyiso3Svok4iQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvATxw/7N24wOlnHHeTIJ18iMqnhtIEcY5t8dFMQsJCk1SyymqnP7bfzc5C0XNaf8
         KaNNOBoMAUCM8QyAKYWnDFGn8QnjAV/OSX7g8A19wX+jJqhdf5AOHiqR0/nFyCWw+O
         XuOfYAyKMwVmKk5z4y+xw3+g2DtIykXBNnfoGNeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 435/475] net: openvswitch: dont send internal clone attribute to the userspace.
Date:   Thu, 14 Apr 2022 15:13:40 +0200
Message-Id: <20220414110907.236543597@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 2c0f8cbc5c43..ae40593daf21 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1037,7 +1037,7 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
 	int rem = nla_len(attr);
 	bool dont_clone_flow_key;
 
-	/* The first action is always 'OVS_CLONE_ATTR_ARG'. */
+	/* The first action is always 'OVS_CLONE_ATTR_EXEC'. */
 	clone_arg = nla_data(attr);
 	dont_clone_flow_key = nla_get_u32(clone_arg);
 	actions = nla_next(clone_arg, &rem);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index e4c23ae9cfe5..d3f068ad154c 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3284,7 +3284,9 @@ static int clone_action_to_attr(const struct nlattr *attr,
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



