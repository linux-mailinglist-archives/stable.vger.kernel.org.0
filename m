Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480176AA4D7
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjCCWyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjCCWyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:54:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8001F499;
        Fri,  3 Mar 2023 14:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C95EB819FC;
        Fri,  3 Mar 2023 21:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC18CC433A0;
        Fri,  3 Mar 2023 21:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879998;
        bh=rWE7k5EKZQsA3EvJludaqMqX9pnkDAExdTKGkMejj1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRB3TkpMvKqngSI1W7dnlgfwGdmKQTOfvW3c4FeySlrVoozCzXPalhSa8wJ1xE3dU
         ibStIZJObzT3nDSDHOOUmMaM2uZP5bf9aFeNjONtzNwGC0YMDaplA1DHw3f5VrR5DQ
         KrqSBa9ZrjVQyT0ulkZhhTjkbZisScl/TCUm9R4yF/3eyy2y3rStlJuUw7X6f8Krfc
         lG6V7nvLSIMOEMKUloyfjWHNPEFvRbUBpzJtapJMqiuQf0bP1OaG3+w0WXeOoQg3HB
         L7Z9wqc3hs/k+uNBwZptx8fK+8Fpac2C735zHntCFJ9quq4mSsHswt4WakQC+MmvXz
         1kNmwOvJc8HvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/50] USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:10 -0500
Message-Id: <20230303214531.1450154-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

