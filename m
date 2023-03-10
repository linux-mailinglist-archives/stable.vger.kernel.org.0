Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04BE6B4251
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjCJOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjCJOBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D551151D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A13361771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B39BC4339B;
        Fri, 10 Mar 2023 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456907;
        bh=KRBEIVoE9JmHAOpRSWS3UjsvllJYFulQOA9LVXLoDQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm5hqd7IvdLR7EGo1gdai9i6oZOzhyx3wK5U483mUwu6iCZC77pWrDLz5vzP9q3kf
         b8Cd5Bo0jHdGNoTxK+dJuVJZLtnDWy+y1FF09b+FYuS+jZUuORulp2tWJqK5p4/ct1
         7u2H8QZ1Lz+CU180wWL4if/rhjP6h97iXZlQjzuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Cernekee <cernekee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 165/211] USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133723.800180304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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
index d04d72f5816e6..8d58928913007 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -2258,7 +2258,7 @@ static void bcm63xx_udc_init_debugfs(struct bcm63xx_udc *udc)
  */
 static void bcm63xx_udc_cleanup_debugfs(struct bcm63xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 /***********************************************************************
-- 
2.39.2



