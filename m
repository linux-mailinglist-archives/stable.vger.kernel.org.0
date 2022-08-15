Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84206594499
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiHOWEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiHOWCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDB682D01;
        Mon, 15 Aug 2022 12:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A10761089;
        Mon, 15 Aug 2022 19:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96580C433C1;
        Mon, 15 Aug 2022 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592225;
        bh=e+q/+ylgS+4pckBS7ntgLisdifqqYTOfxAfl92z1mJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldZ04HBmFzXqkl1zQdxa01gsLCsC0EdZkwybkz1w0gyPmev5bTlLMCAYDrpH/oYlo
         6sXNjVmDqrzi9jzl1M9VRUop3CKX7IijlpPwHI7KaAuuXQlrbrH6pRtJ0GUwfJp26D
         5YaVgjWa+Ydg6T0yxPyI9Xm4bagiV1fYWnzooAjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0752/1095] xtensa: iss/network: provide release() callback
Date:   Mon, 15 Aug 2022 20:02:31 +0200
Message-Id: <20220815180500.450054728@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 8864fb8359682912ee99235db7db916733a1fd7b ]

Provide release() callback for the platform device embedded into struct
iss_net_private and registered in the iss_net_configure so that
platform_device_unregister could be called for it.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/iss/network.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index be3aaaad8bee..24f162bd5874 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -503,6 +503,15 @@ static const struct net_device_ops iss_netdev_ops = {
 	.ndo_set_rx_mode	= iss_net_set_multicast_list,
 };
 
+static void iss_net_pdev_release(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct iss_net_private *lp =
+		container_of(pdev, struct iss_net_private, pdev);
+
+	free_netdev(lp->dev);
+}
+
 static int iss_net_configure(int index, char *init)
 {
 	struct net_device *dev;
@@ -559,6 +568,7 @@ static int iss_net_configure(int index, char *init)
 
 	lp->pdev.id = index;
 	lp->pdev.name = DRIVER_NAME;
+	lp->pdev.dev.release = iss_net_pdev_release;
 	platform_device_register(&lp->pdev);
 	SET_NETDEV_DEV(dev, &lp->pdev.dev);
 
-- 
2.35.1



