Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D679C6AA2C2
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbjCCVv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbjCCVtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DC66C19D;
        Fri,  3 Mar 2023 13:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF2B0B818A4;
        Fri,  3 Mar 2023 21:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BEC4339C;
        Fri,  3 Mar 2023 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879948;
        bh=vWjZYVCyqOa7QEyu/N9kEW1AAi5cQG0o8QSHeR20/1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGSWCei1wxt27eBuBpAh3SjuIdmr/PfxrhFLm0cvZIZzdtUao0lFQa9RyT4HhmL6Z
         XLLC9uEk2ntwUBz5jM4v018vR9wWYoDV7zt+q9ZGO+4UfQLm4VhpdBG2LHkK//inpu
         5Y5c7SxnRc+UQu2/DCGdxAP2rdRM56IqwjmkibxLZiPmW/JwD3rSWo2l/sk/CdINUQ
         4WObhPDRJkkHUj+XkBPs9pJZ6M7BPQuHLLPchuPYIvJAK0PTzcEL9f2AYPD87brpBs
         lM6vFlYajo/oRgpDLUN6NvlSqE7ZDJq54WhKTp7315lgeq/dJ3d405c7vdJjuzRAed
         k8m+o+0UPIqtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jilin Yuan <yuanjilin@cdjrlc.com>,
        Sasha Levin <sashal@kernel.org>, hdegoede@redhat.com,
        vkoul@kernel.org, mchehab@kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/50] USB: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:44:49 -0500
Message-Id: <20230303214531.1450154-8-sashal@kernel.org>
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

[ Upstream commit 30374434edab20e25776f8ecb4bc9d1e54309487 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>
Link: https://lore.kernel.org/r/20230106152828.3790902-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 62368c4ed37af..cc36f9f228148 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1036,7 +1036,7 @@ static void usb_debugfs_init(void)
 
 static void usb_debugfs_cleanup(void)
 {
-	debugfs_remove(debugfs_lookup("devices", usb_debug_root));
+	debugfs_lookup_and_remove("devices", usb_debug_root);
 }
 
 /*
-- 
2.39.2

