Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07BD5B6FF0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiIMOUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiIMOSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA15D4BA70;
        Tue, 13 Sep 2022 07:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD14614CC;
        Tue, 13 Sep 2022 14:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C85AC433C1;
        Tue, 13 Sep 2022 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078399;
        bh=Hfp0IEw+QbmUcWV4SihUapHzQQnf43J0kCrFSKMNcR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJooQ2orfvFu/0buExyNwV2g3MLfByfoXkiDEkVb/I35UM4R1AWu3W8l1WFy1bmAQ
         uFrpVQd3iUKOuMCwR0fh/rpN7vpAy8VYE1LcJIHxtW8qKLbHYHmfW/7xY+GvqzqvdY
         eS8TrC+z1e9/Rt4wjiesVqUNYTEu1u8giS65BdYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 124/192] xen-netback: only remove hotplug-status when the vif is actually destroyed
Date:   Tue, 13 Sep 2022 16:03:50 +0200
Message-Id: <20220913140416.175571493@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Paul Durrant <pdurrant@amazon.com>

[ Upstream commit c55f34b6aec2a8cb47eadaffea773e83bf85de91 ]

Removing 'hotplug-status' in backend_disconnected() means that it will be
removed even in the case that the frontend unilaterally disconnects (which
it is free to do at any time). The consequence of this is that, when the
frontend attempts to re-connect, the backend gets stuck in 'InitWait'
rather than moving straight to 'Connected' (which it can do because the
hotplug script has already run).
Instead, the 'hotplug-status' mode should be removed in netback_remove()
i.e. when the vif really is going away.

Fixes: 0f4558ae9187 ("Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"")
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 990360d75cb64..e85b3c5d4acce 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -256,7 +256,6 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
@@ -984,6 +983,7 @@ static int netback_remove(struct xenbus_device *dev)
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
 	unregister_hotplug_status_watch(be);
+	xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		backend_disconnect(be);
-- 
2.35.1



