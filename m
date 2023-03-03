Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC3D6AA3D8
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjCCWIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbjCCWIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:08:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1316C68B;
        Fri,  3 Mar 2023 13:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF38361944;
        Fri,  3 Mar 2023 21:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEC1C433A1;
        Fri,  3 Mar 2023 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879896;
        bh=ENlRig7qxIZqwpN/qXepTWkVpECOpKSodtH0h5/Rp70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4E3AyiVOZKfiFs35WzgFiCvjI9SK4+oVcVW0ALHtmspZPOkvB7OCi/txQMO1C1Vb
         i9VtUn9vIZvz3/kSeBaB7D/+KjRi1fr1hX6uP68x6VF5piZ7SgwDXob61xyzc5h+XR
         /AtecpKJNHmyKsJLNzyCJ7rvP21HYhgqoX6e2BbmMMCwqp4XT05h6nd8dDq1RhsAu9
         IkpISpoRarVUXMo8gyQsWH38sbP16BqHtYDEvBeYKLgcVQ923XQhDluZb5LjxiW6k5
         OPjIUOh1ELEEObhlALjtpKYxwrFdvMRsUcVHd+856uHp8b4c5Qeu7TmCkDbObUOcKx
         CSl9YV5UI4Pww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nadav Amit <namit@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 47/60] misc: vmw_balloon: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:43:01 -0500
Message-Id: <20230303214315.1447666-47-sashal@kernel.org>
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

[ Upstream commit 209cdbd07cfaa4b7385bad4eeb47e5ec1887d33d ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Cc: Nadav Amit <namit@vmware.com>
Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230202141100.2291188-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 61a2be712bf7b..9ce9b9e0e9b63 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1709,7 +1709,7 @@ static void __init vmballoon_debugfs_init(struct vmballoon *b)
 static void __exit vmballoon_debugfs_exit(struct vmballoon *b)
 {
 	static_key_disable(&balloon_stat_enabled.key);
-	debugfs_remove(debugfs_lookup("vmmemctl", NULL));
+	debugfs_lookup_and_remove("vmmemctl", NULL);
 	kfree(b->stats);
 	b->stats = NULL;
 }
-- 
2.39.2

