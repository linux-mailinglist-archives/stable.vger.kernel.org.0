Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0E16B4AF6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbjCJP2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjCJP2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CEB141624
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB64D61A01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A8DC433D2;
        Fri, 10 Mar 2023 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461377;
        bh=jPjRG8J2Lw/T6MTjpltlKQ/ub2il2H98DaZwP94Z7O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L62C2REpD6TW5lGmVjW4aqu2J2uQWAqiZ9Z3uESPV74gKdkzhz2E1caX9uLLNPOrC
         BxDBXm4yi1HYTQ+Q6pvr7isWSsYadPNo+078TGKBBymvNSwv793LZ6S5DOKTVSuXE/
         iXI1yWMOalgHyidhidUzYYmSQq5uedVNDIFFI+gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/136] drivers: base: dd: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:43:59 +0100
Message-Id: <20230310133710.752353286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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
index 060348125635b..9cbf086fe5524 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -352,7 +352,7 @@ late_initcall(deferred_probe_initcall);
 
 static void __exit deferred_probe_exit(void)
 {
-	debugfs_remove_recursive(debugfs_lookup("devices_deferred", NULL));
+	debugfs_lookup_and_remove("devices_deferred", NULL);
 }
 __exitcall(deferred_probe_exit);
 
-- 
2.39.2



