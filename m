Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAE26AA4E6
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjCCWzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjCCWyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B778698;
        Fri,  3 Mar 2023 14:54:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9ACB819F8;
        Fri,  3 Mar 2023 21:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDF8C4339C;
        Fri,  3 Mar 2023 21:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879997;
        bh=fdKo/Y+cTzpEvjKupQZ62jfPlLN615ljJ0SnBXTuHkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYjDUscBttLtGmQmp+tuQDquQ0yc0N4Wey+eDPnWXE/aD8cujlidHyr9evtKT4Eun
         zNwotQDfIKyeQDBmTAEDCTvv0/StMRPqQ7KAoIibGDhMijEIEO4LNgjfkZ92T6K+rA
         KvagKzyhzytDZTkh6hKqcC68mBr3VPhjxMdajTddna2fDNU1IJKqk2Wc+RJsCkJxIu
         dqkGkaELypnnyIuQy5AbR6tmmZZPMYx6YuEdoDCgHUpm5EE4q/ab0VEHLly2/xuJbc
         ffvAJBLtgKywhGtmfyDiWNIIYoGGrx0mExaEEChzODfmwdLfYSNkBu7PmPqZKH0wXV
         2rbNmUIYkS0RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Sasha Levin <sashal@kernel.org>, aaro.koskinen@iki.fi,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/50] USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:09 -0500
Message-Id: <20230303214531.1450154-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 73f4451368663ad28daa67980c6dd11d83b303eb ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-8-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/gr_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 4b35739d36951..d1febde6f2c4a 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -215,7 +215,7 @@ static void gr_dfs_create(struct gr_udc *dev)
 
 static void gr_dfs_delete(struct gr_udc *dev)
 {
-	debugfs_remove(debugfs_lookup(dev_name(dev->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(dev->dev), usb_debug_root);
 }
 
 #else /* !CONFIG_USB_GADGET_DEBUG_FS */
-- 
2.39.2

