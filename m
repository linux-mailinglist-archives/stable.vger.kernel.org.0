Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD886AA265
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjCCVrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjCCVq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8116F64215;
        Fri,  3 Mar 2023 13:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FB3F61919;
        Fri,  3 Mar 2023 21:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111D9C4339B;
        Fri,  3 Mar 2023 21:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879871;
        bh=6Gs71kEKBpwp4cOkCn7i/3BhX3OpriQWHrFXzoQuGIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNQ3KI+O9D2hgUjXak6uEYB5PsIvJzZxyHNKc+GH4F6uPW5Sb0sz7MtkGpa6ub/8F
         DskDQRdVxP4byq59iSgWzxEuT+P3PdQzT5/nWlkN8x0ZzJekDxdCTllusD+xP/tk3K
         2xmcos3N5x9L+ZhhBs+kVWeywivGLPXRNVOrDqS0IrQY/xj8D/9iSGuZqyLshyNCOC
         eLNB0vvZwQ53OLAJH1RvbD+DF4QGKlowGkbqO7te3Tq23E1Bc/ILQ9QZLWjy5DK8Fx
         41m3KbvzWUWIl+Yfzs6bJ9itNVtW94xkr5w0ptJzaxTq1D3SSl62hqq5O7UOhtJzHX
         /M5oZd18hqFfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        aaro.koskinen@iki.fi, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 34/60] USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:48 -0500
Message-Id: <20230303214315.1447666-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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
index 85cdc0af3bf95..09762559912d3 100644
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

