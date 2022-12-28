Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DC6582B5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbiL1Qks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiL1Qjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:39:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEFB1E714
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:34:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 227F9B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A8BC433EF;
        Wed, 28 Dec 2022 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245294;
        bh=xoRy9IjnKps7dsevsWvzEuaCv6ENyEGDIybZk6Q2iwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+DREufi3JjyhC6EiGRdvnCa6owUfzLK9n+hsTnDhnpNHqaQ/VjSRTjl0SM+8OAQW
         pw07xMN0SfWk5YoLXTW+AXtAQ9ivgMfZ3O2XMWYOga19PQmcqphr9JSSaeYGvxb4bT
         fZT86DqE281nOnjqHdk2Ngv/tb+coW7Gb0qs3IAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0868/1073] devlink: hold region lock when flushing snapshots
Date:   Wed, 28 Dec 2022 15:40:56 +0100
Message-Id: <20221228144351.598112408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b4cafb3d2c740f8d1b1234b43ac4a60e5291c960 ]

Netdevsim triggers a splat on reload, when it destroys regions
with snapshots pending:

  WARNING: CPU: 1 PID: 787 at net/core/devlink.c:6291 devlink_region_snapshot_del+0x12e/0x140
  CPU: 1 PID: 787 Comm: devlink Not tainted 6.1.0-07460-g7ae9888d6e1c #580
  RIP: 0010:devlink_region_snapshot_del+0x12e/0x140
  Call Trace:
   <TASK>
   devl_region_destroy+0x70/0x140
   nsim_dev_reload_down+0x2f/0x60 [netdevsim]
   devlink_reload+0x1f7/0x360
   devlink_nl_cmd_reload+0x6ce/0x860
   genl_family_rcv_msg_doit.isra.0+0x145/0x1c0

This is the locking assert in devlink_region_snapshot_del(),
we're supposed to be holding the region->snapshot_lock here.

Fixes: 2dec18ad826f ("net: devlink: remove region snapshots list dependency on devlink->lock")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cfa6a099457a..b3a869ccc8ed 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11358,8 +11358,10 @@ void devl_region_destroy(struct devlink_region *region)
 	devl_assert_locked(devlink);
 
 	/* Free all snapshots of region */
+	mutex_lock(&region->snapshot_lock);
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
 		devlink_region_snapshot_del(region, snapshot);
+	mutex_unlock(&region->snapshot_lock);
 
 	list_del(&region->list);
 	mutex_destroy(&region->snapshot_lock);
-- 
2.35.1



