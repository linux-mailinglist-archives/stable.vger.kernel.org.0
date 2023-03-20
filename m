Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0178B6C161F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjCTPCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjCTPBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EC835A5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E560161573
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB4C433EF;
        Mon, 20 Mar 2023 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324304;
        bh=0MSvBl9R0c0LGoO6cIDWuRlDasAs2SR9aA+EtO5kijc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXkYbYPI42zdWAepx3hQp9SPFknjvzd8DYNovCiJEq7GPzPdzALw0WQaSrZ+UCCxp
         fuGavlDjdwu/8GWmBfxQqDRbTurq9Vio/N6BUN3aC4t5SY96jusi9hMBOoQ++jqGaY
         5k9HQX5UH/SPB2gXdB6C9xno72/ll4bCA4lvjy1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/30] ethernet: sun: add check for the mdesc_grab()
Date:   Mon, 20 Mar 2023 15:54:39 +0100
Message-Id: <20230320145420.782489249@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 90de546d9a0b3c771667af18bb3f80567eabb89b ]

In vnet_port_probe() and vsw_port_probe(), we should
check the return value of mdesc_grab() as it may
return NULL which can caused NPD bugs.

Fixes: 5d01fa0c6bd8 ("ldmvsw: Add ldmvsw.c driver code")
Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/ldmvsw.c  | 3 +++
 drivers/net/ethernet/sun/sunvnet.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index e6b96c2989b22..f0a8e3598057e 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -289,6 +289,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 02ebbe74d93de..824f5951ad507 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -430,6 +430,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
-- 
2.39.2



