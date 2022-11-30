Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7D63DD76
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiK3S1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiK3S10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71878C47C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724DF61D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F205C433C1;
        Wed, 30 Nov 2022 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832844;
        bh=MrW+MLMnSaaz552UWpAVfbRHkwkLHvHiI3bRh2/NUi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFTVTbJX4FnkwnBzK4pLOl4+IscIhF/k2QP+d9wQc7A5+Er7EmmF9/D92fqcpaCSv
         ijN3RiRPbtCdjGjbEk4O2O2w0OiZKedJAB7Xume7BoU63rOqrS+xFHhbONWBOs3HNH
         xY6lu3WRSMgsm3I6AA8+3HN6TZLoE1NuoNWzci10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Diana Wang <na.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/162] nfp: fill splittable of devlink_port_attrs correctly
Date:   Wed, 30 Nov 2022 19:22:21 +0100
Message-Id: <20221130180530.135603944@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Diana Wang <na.wang@corigine.com>

[ Upstream commit 4abd9600b9d15d3d92a9ac25cf200422a4c415ee ]

The error is reflected in that it shows wrong splittable status of
port when executing "devlink port show".
The reason which leads the error is that the assigned operation of
splittable is just a simple negation operation of split and it does
not consider port lanes quantity. A splittable port should have
several lanes that can be split(lanes quantity > 1).
If without the judgement, it will show wrong message for some
firmware, such as 2x25G, 2x10G.

Fixes: a0f49b548652 ("devlink: Add a new devlink port split ability attribute and pass to netlink")
Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 7a8187458724..24578c48f075 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -363,7 +363,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
-	attrs.splittable = !attrs.split;
+	attrs.splittable = eth_port.port_lanes > 1 && !attrs.split;
 	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
-- 
2.35.1



