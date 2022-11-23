Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477386356D7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiKWJgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbiKWJgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:36:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C941DDEAE2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:33:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EBB3CE20F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F07C433B5;
        Wed, 23 Nov 2022 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196006;
        bh=XmYnc1+Jf9mCeXr1+9JXPveFSZZl5VTLrHQRVPPtdY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaNe8RmQzJGWLYhNf3hym3JvdLKr1MX1CLi9grwuowdZJJRZFx3x4w2m4BEf7167W
         ciC86jnBNZvVS0jSdL8+9QdmhClPGJnjf83LF6g+rCzsVrDpe4PDCLYlv4TsQupLhN
         vs0JGliFnpwLnZpSeA/0PV2RMgi7lt+r9REODz4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/181] net: ionic: Fix error handling in ionic_init_module()
Date:   Wed, 23 Nov 2022 09:50:55 +0100
Message-Id: <20221123084606.295853136@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 280c0f7cd0aa4d190619b18243110e052a90775c ]

A problem about ionic create debugfs failed is triggered with the
following log given:

 [  415.799514] debugfs: Directory 'ionic' with parent '/' already present!

The reason is that ionic_init_module() returns ionic_bus_register_driver()
directly without checking its return value, if ionic_bus_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of ionic can never be created later.

 ionic_init_module()
   ionic_debugfs_create() # create debugfs directory
   ionic_bus_register_driver()
     pci_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when ionic_bus_register_driver() returns error.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20221113092929.19161-1-yuancan@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 9ede66842118..538c024afed5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -588,8 +588,14 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
+	int ret;
+
 	ionic_debugfs_create();
-	return ionic_bus_register_driver();
+	ret = ionic_bus_register_driver();
+	if (ret)
+		ionic_debugfs_destroy();
+
+	return ret;
 }
 
 static void __exit ionic_cleanup_module(void)
-- 
2.35.1



