Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16F4F2F5A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbiDEIfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiDEIT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CC385BEB;
        Tue,  5 Apr 2022 01:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B18EDB81B92;
        Tue,  5 Apr 2022 08:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F66C385A1;
        Tue,  5 Apr 2022 08:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146272;
        bh=DbvDUCjs6PJjOYcbBZnASjkLrK3/Xw+n/fw/88LNon8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v81NYQq11gaLjJZ7dJAAx9tWs1WI4wlYQdKqVlyhDtsJJ22YkFhDJV06GoTkehuWb
         PiLmZ4fC7Kn4Shxl5UQWiqcfbFAdVVtbRW+mjcHv7jqUOXmDnt1wijrRkNN5n/aMcl
         QJS7G/6ez8lGz9vMm95GHiooVnw/8CoSOT4uaBYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0703/1126] net: dsa: fix panic on shutdown if multi-chip tree failed to probe
Date:   Tue,  5 Apr 2022 09:24:10 +0200
Message-Id: <20220405070428.239374191@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8fd36358ce82382519b50b05f437493e1e00c4a9 ]

DSA probing is atypical because a tree of devices must probe all at
once, so out of N switches which call dsa_tree_setup_routing_table()
during probe, for (N - 1) of them, "complete" will return false and they
will exit probing early. The Nth switch will set up the whole tree on
their behalf.

The implication is that for (N - 1) switches, the driver binds to the
device successfully, without doing anything. When the driver is bound,
the ->shutdown() method may run. But if the Nth switch has failed to
initialize the tree, there is nothing to do for the (N - 1) driver
instances, since the slave devices have not been created, etc. Moreover,
dsa_switch_shutdown() expects that the calling @ds has been in fact
initialized, so it jumps at dereferencing the various data structures,
which is incorrect.

Avoid the ensuing NULL pointer dereferences by simply checking whether
the Nth switch has previously set "ds->setup = true" for the switch
which is currently shutting down. The entire setup is serialized under
dsa2_mutex which we already hold.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220318195443.275026-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 88e2808019b4..a39bbed77f87 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1722,6 +1722,10 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
+
+	if (!ds->setup)
+		goto out;
+
 	rtnl_lock();
 
 	dsa_switch_for_each_user_port(dp, ds) {
@@ -1738,6 +1742,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 		dp->master->dsa_ptr = NULL;
 
 	rtnl_unlock();
+out:
 	mutex_unlock(&dsa2_mutex);
 }
 EXPORT_SYMBOL_GPL(dsa_switch_shutdown);
-- 
2.34.1



