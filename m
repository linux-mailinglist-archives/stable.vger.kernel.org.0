Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56C6B4AC6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbjCJP0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbjCJP0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:26:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF2B1125A5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F0761A70
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE69C433EF;
        Fri, 10 Mar 2023 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461333;
        bh=fdKo/Y+cTzpEvjKupQZ62jfPlLN615ljJ0SnBXTuHkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQKg1xzVKqy7Q5SPh2LULapN9Bq6MjwxrnIBGKlB8Tl99/sxQZj05Fonh37OlEbZh
         UNOevWoCN93Ew7cUvw9SqC5g+igMRmoxzV+Ly87TWDEalS5Rgkrtd7K1Om/TXAZiEc
         6csEQYp7jka2CNXCrffv3rMVEAMz4zHBxJxp9e48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakob Koschel <jakobkoschel@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/136] USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:45 +0100
Message-Id: <20230310133710.265002213@linuxfoundation.org>
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



