Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC76B4232
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjCJOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjCJOAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:00:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE20B116B9B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30FFF617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258E4C4339B;
        Fri, 10 Mar 2023 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456831;
        bh=F3Q4jKopnnXfzlnJ8qnU5EeFLtFycAZFH7iwqJimz+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLoLTfztw2TTvf2/bofEzHChxQump/D1trsyWJXgi6AJUyLtrSqOoy7c+974qA2VS
         99G+ngFUkPVGU9B7I2DGxsqEdZ8hkDq/zZrOmjXg1c5MMEOfyHVdZ5R3CgXWqve2jT
         CTQmnjSLafth0TaivogBBT6BtbpDxsx/4HosR8ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Jilin Yuan <yuanjilin@cdjrlc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 138/211] USB: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:38:38 +0100
Message-Id: <20230310133722.934253481@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 11b15d7b357ad..a415206cab043 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -998,7 +998,7 @@ static void usb_debugfs_init(void)
 
 static void usb_debugfs_cleanup(void)
 {
-	debugfs_remove(debugfs_lookup("devices", usb_debug_root));
+	debugfs_lookup_and_remove("devices", usb_debug_root);
 }
 
 /*
-- 
2.39.2



