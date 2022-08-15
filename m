Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169C759399C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244007AbiHOTYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245060AbiHOTWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:22:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6633B59270;
        Mon, 15 Aug 2022 11:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AA2BCE1268;
        Mon, 15 Aug 2022 18:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EC6C433C1;
        Mon, 15 Aug 2022 18:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588835;
        bh=+xyQPqQ4x+0wzOxEiX4hNX96Q1C0zM0bt8z0jZmfowU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFlCN/iCs2uPBGH1OWBJ6YDKyCfbxQHxKYTmzgSOtoPpyeck72cldVaoKwILAObyf
         ls4nzzVUsTum6F3ryevDrfqpha9s8e5o3sl0CLlZuV+0OucHecdeSKKhTGr4NNWmcf
         O2XLbZsQEzcV87WLmrl14VHD3YIt4CIXSsa4M/i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 488/779] xtensa: iss/network: provide release() callback
Date:   Mon, 15 Aug 2022 20:02:12 +0200
Message-Id: <20220815180358.122109382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 4986226a5ab2..4801df4e73e1 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -502,6 +502,15 @@ static const struct net_device_ops iss_netdev_ops = {
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
@@ -558,6 +567,7 @@ static int iss_net_configure(int index, char *init)
 
 	lp->pdev.id = index;
 	lp->pdev.name = DRIVER_NAME;
+	lp->pdev.dev.release = iss_net_pdev_release;
 	platform_device_register(&lp->pdev);
 	SET_NETDEV_DEV(dev, &lp->pdev.dev);
 
-- 
2.35.1



