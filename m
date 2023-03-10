Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64FC6B4287
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCJOEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjCJOEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50115AB7A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 654876191F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648FEC433D2;
        Fri, 10 Mar 2023 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457030;
        bh=QIksLOTKxJRO+YhmoAGEvE/OjudrTc2cq7yyNzLfAiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/52nfS5eUcvpRLF/Tgcd32Yel3MKl7EtwnAHH+8OG7cYL53x+/nuQm1nzuVOZDqC
         CdIPSzijsl9u2SkeQmbR7s5+W9w171F2Y35Y8t4C23eYUeHKtLqXb2PKed4CsicZju
         ev+1JRmVAL7SkR9knMcmguHPZNMi/M85kKxGTJ04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 179/211] drivers: base: dd: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:19 +0100
Message-Id: <20230310133724.266669525@linuxfoundation.org>
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

[ Upstream commit 36c893d3a759ae7c91ee7d4871ebfc7504f08c40 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230202141621.2296458-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e9b2f9c25efe4..959fe018d0dd7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -372,7 +372,7 @@ late_initcall(deferred_probe_initcall);
 
 static void __exit deferred_probe_exit(void)
 {
-	debugfs_remove_recursive(debugfs_lookup("devices_deferred", NULL));
+	debugfs_lookup_and_remove("devices_deferred", NULL);
 }
 __exitcall(deferred_probe_exit);
 
-- 
2.39.2



