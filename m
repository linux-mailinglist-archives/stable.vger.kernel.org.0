Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5170E6B424D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjCJOBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjCJOBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A565B1165F7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B172B822BE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935C7C4339B;
        Fri, 10 Mar 2023 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456898;
        bh=gpUSKB3kC9G6mWSenLq1kBUG6QCbvz++Xvx6mViL4wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWGXQKWFYvKXQv59DfZJ45PLBPS32uW0SnQtSssYHz+UfrXUCG6hvMcxjbwRjAKMq
         PQ8+cC/IixHcQ0YmHijEuu5D5+laNfVN4Jud4WG9hFE2kvXjCWSM0lm7UcVD/eLCcN
         8bfB/rb8+qWBOEoEVxGFqqs30p241rBe7w5VYkCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Olav Kongas <ok@artecdesign.ee>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 162/211] USB: isp116x: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:02 +0100
Message-Id: <20230310133723.690142299@linuxfoundation.org>
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

[ Upstream commit a95f62d5813facbec20ec087472eb313ee5fa8af ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Olav Kongas <ok@artecdesign.ee>
Link: https://lore.kernel.org/r/20230202153235.2412790-6-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp116x-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 4f564d71bb0bc..49ae01487af4d 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1205,7 +1205,7 @@ static void create_debug_file(struct isp116x *isp116x)
 
 static void remove_debug_file(struct isp116x *isp116x)
 {
-	debugfs_remove(debugfs_lookup(hcd_name, usb_debug_root));
+	debugfs_lookup_and_remove(hcd_name, usb_debug_root);
 }
 
 #else
-- 
2.39.2



