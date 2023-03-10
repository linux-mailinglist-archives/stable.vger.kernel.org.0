Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F786B4AEF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjCJP2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbjCJP1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:27:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2ED10EAB1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9707D61962
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4CFC433A8;
        Fri, 10 Mar 2023 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461336;
        bh=rWE7k5EKZQsA3EvJludaqMqX9pnkDAExdTKGkMejj1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c496YeCDfnHeOxGeqUiclSu7u4GJ98BYL+NExBSsswRR3R6x7+s0TMpHpxafAjkXa
         DaAk0xhb021ZHh5V7Jzpa42Hzhh/jEotGNwb81SJubtzXm/gv3llHYR7MQ+Th5njqa
         4a0ISYM9tSTnPipsHhJzBqVDwsllWMoeraM4P2J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Cernekee <cernekee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/136] USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:46 +0100
Message-Id: <20230310133710.303288864@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a91c99b1fe5c6f7e52fb932ad9e57ec7cfe913ec ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Kevin Cernekee <cernekee@gmail.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-9-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bcm63xx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/udc/bcm63xx_udc.c
index a9f07c59fc377..5c7dff6bc638f 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -2259,7 +2259,7 @@ static void bcm63xx_udc_init_debugfs(struct bcm63xx_udc *udc)
  */
 static void bcm63xx_udc_cleanup_debugfs(struct bcm63xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 /***********************************************************************
-- 
2.39.2



