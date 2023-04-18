Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C10D6E6227
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjDRMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjDRMag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0795F9745
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D842B628B4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE42C433EF;
        Tue, 18 Apr 2023 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821011;
        bh=7LJsVNJ2rR6x+imfW+SKJekzRAERi49kYq9zjNhRXnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qC/kcrsb2mYp71kw59wXlYkU8SKZVWrb+aYpia4wHErFO7/QcvYLm3IDGTlZHrOTR
         OxnoRhILCNida/6DLoDek1zsya5D3RuKK5RvpUq3JqkM3BS6wnTmTn/UISuiT5c37j
         MOze9kDRIezCZRFBa2YUYIj3yqLcQFv76O+2koqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/92] 9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition
Date:   Tue, 18 Apr 2023 14:21:32 +0200
Message-Id: <20230418120306.840095281@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit ea4f1009408efb4989a0f139b70fb338e7f687d0 ]

In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
to init priv->rings and bound &ring->work with p9_xen_response.

When it calls xen_9pfs_front_event_handler to handle IRQ requests,
it will finally call schedule_work to start the work.

When we call xen_9pfs_front_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in xen_9pfs_front_free.

Note that, this bug is found by static analysis, which might be
false positive.

CPU0                  CPU1

                     |p9_xen_response
xen_9pfs_front_remove|
  xen_9pfs_front_free|
kfree(priv)          |
//free priv          |
                     |p9_tag_lookup
                     |//use priv->client

Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 67e9a7085e13b..4a16c5dd1576d 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -299,6 +299,10 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-- 
2.39.2



