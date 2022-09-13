Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CE75B7175
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiIMOgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiIMOfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF5865555;
        Tue, 13 Sep 2022 07:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB59B80FB5;
        Tue, 13 Sep 2022 14:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D745C433D6;
        Tue, 13 Sep 2022 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078796;
        bh=Hfp0IEw+QbmUcWV4SihUapHzQQnf43J0kCrFSKMNcR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGmcBrwMbhjT4MSVmDkkVgWXl0VWJ+kZSwUsiVwu/y1SRxwIfNIncuddXj5PJnYsQ
         NPN0y4Sh/nLAk/foOxfxLE/G4VZrWOfHsmgro6BEzbVvouZu6gg53WZqXj08/RzOxn
         vllSz8VZwNfYcb4GhXWgpCZeFvSsG8wSS4voJS90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/121] xen-netback: only remove hotplug-status when the vif is actually destroyed
Date:   Tue, 13 Sep 2022 16:04:36 +0200
Message-Id: <20220913140401.023100271@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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



