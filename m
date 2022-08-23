Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45F59D3BF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiHWISq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243053AbiHWIQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EE869F4B;
        Tue, 23 Aug 2022 01:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F4461257;
        Tue, 23 Aug 2022 08:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9F5C433C1;
        Tue, 23 Aug 2022 08:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242265;
        bh=X64jWE4sYmXdajzHGjPAcpzNUpOWDxH6QKW+V8PUFBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyo9z05no06eVUUDySlDZIoHHoG7Zq/+379K/6Q5wQB8rgtEI3RjmxkB9S6hT01+i
         REqaNbZB8BuUEFNay7Ob/AfRYppn40xX+L5X5x2bMj7HzUoc4klLPIF5HZ6vJ0tKy4
         h3bTe9aWZVeHQHiKtqrRj/6yxgsiWNpo5dQSc+qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 085/365] net: dsa: felix: suppress non-changes to the tagging protocol
Date:   Tue, 23 Aug 2022 09:59:46 +0200
Message-Id: <20220823080121.746982636@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 4c46bb49460ee14c69629e813640d8b929e88941 upstream.

The way in which dsa_tree_change_tag_proto() works is that when
dsa_tree_notify() fails, it doesn't know whether the operation failed
mid way in a multi-switch tree, or it failed for a single-switch tree.
So even though drivers need to fail cleanly in
ds->ops->change_tag_protocol(), DSA will still call dsa_tree_notify()
again, to restore the old tag protocol for potential switches in the
tree where the change did succeeed (before failing for others).

This means for the felix driver that if we report an error in
felix_change_tag_protocol(), we'll get another call where proto_ops ==
old_proto_ops. If we proceed to act upon that, we may do unexpected
things. For example, we will call dsa_tag_8021q_register() twice in a
row, without any dsa_tag_8021q_unregister() in between. Then we will
actually call dsa_tag_8021q_unregister() via old_proto_ops->teardown,
which (if it manages to run at all, after walking through corrupted data
structures) will leave the ports inoperational anyway.

The bug can be readily reproduced if we force an error while in
tag_8021q mode; this crashes the kernel.

echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
echo edsa > /sys/class/net/eno2/dsa/tagging # -EPROTONOSUPPORT

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000014
Call trace:
 vcap_entry_get+0x24/0x124
 ocelot_vcap_filter_del+0x198/0x270
 felix_tag_8021q_vlan_del+0xd4/0x21c
 dsa_switch_tag_8021q_vlan_del+0x168/0x2cc
 dsa_switch_event+0x68/0x1170
 dsa_tree_notify+0x14/0x34
 dsa_port_tag_8021q_vlan_del+0x84/0x110
 dsa_tag_8021q_unregister+0x15c/0x1c0
 felix_tag_8021q_teardown+0x16c/0x180
 felix_change_tag_protocol+0x1bc/0x230
 dsa_switch_event+0x14c/0x1170
 dsa_tree_change_tag_proto+0x118/0x1c0

Fixes: 7a29d220f4c0 ("net: dsa: felix: reimplement tagging protocol change with function pointers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220808125127.3344094-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 859196898a7d..aadb0bd7c24f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -610,6 +610,9 @@ static int felix_change_tag_protocol(struct dsa_switch *ds,
 
 	old_proto_ops = felix->tag_proto_ops;
 
+	if (proto_ops == old_proto_ops)
+		return 0;
+
 	err = proto_ops->setup(ds);
 	if (err)
 		goto setup_failed;
-- 
2.37.2



