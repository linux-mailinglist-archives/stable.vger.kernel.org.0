Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53714635863
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiKWJ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiKWJza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:55:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC771165BC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 698A6B81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952FCC433C1;
        Wed, 23 Nov 2022 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197052;
        bh=z+si0tkDvWJ4oWmCX5HaPjTwpocGqSm+tuzxqgEi988=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VU66CQknHcMfvP22j5nNaQyV+Izk41gMzvjX/Upy9+B0HlmXa2wctsPu0/jBc9Cz1
         WQjS/33QTlvdRnJiUnY6/BhSgKGom6JtiPbJYZn7aoavsK7GgYiFxj2zbqhk2ykdb0
         RhoXQdVdThNSqs4jcSLXrHgU53QRkHIA2xWp1/bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 185/314] net: dsa: dont leak tagger-owned storage on switch driver unbind
Date:   Wed, 23 Nov 2022 09:50:30 +0100
Message-Id: <20221123084633.954160545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4e0c19fcb8b5323716140fa82b79aa9f60e60407 ]

In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
storage for private and shared data"), we had a call to
tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
tree teardown time.

There were problems with connecting to a switch tree as a whole, so this
got reworked to connecting to individual switches within the tree. In
this process, tag_ops->disconnect(ds) was made to be called only from
switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
changes), but the normal driver teardown code path wasn't replaced with
anything.

Solve this problem by adding a function that does the opposite of
dsa_switch_setup_tag_protocol(), which is called from the equivalent
spot in dsa_switch_teardown(). The positioning here also ensures that we
won't have any use-after-free in tagging protocol (*rcv) ops, since the
teardown sequence is as follows:

dsa_tree_teardown
-> dsa_tree_teardown_master
   -> dsa_master_teardown
      -> unsets master->dsa_ptr, making no further packets match the
         ETH_P_XDSA packet type handler
-> dsa_tree_teardown_ports
   -> dsa_port_teardown
      -> dsa_slave_destroy
         -> unregisters DSA net devices, there is even a synchronize_net()
            in unregister_netdevice_many()
-> dsa_tree_teardown_switches
   -> dsa_switch_teardown
      -> dsa_switch_teardown_tag_protocol
         -> finally frees the tagger-owned storage

Fixes: 7f2973149c22 ("net: dsa: make tagging protocols connect to individual switches from a tree")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221114143551.1906361-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e537655e442b..befa954b0a47 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -850,6 +850,14 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	return err;
 }
 
+static void dsa_switch_teardown_tag_protocol(struct dsa_switch *ds)
+{
+	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
+
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(ds);
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -953,6 +961,8 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->slave_mii_bus = NULL;
 	}
 
+	dsa_switch_teardown_tag_protocol(ds);
+
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
 
-- 
2.35.1



