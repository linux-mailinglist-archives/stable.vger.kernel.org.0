Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842F26AA337
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjCCVz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjCCVyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:54:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205AD66D0D;
        Fri,  3 Mar 2023 13:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5904A61957;
        Fri,  3 Mar 2023 21:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C247C433A0;
        Fri,  3 Mar 2023 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880024;
        bh=XHXaJL1i0FkVjKGw8UFe95MsqmnTD8jHzWw6U0fKQ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTvpkV1DQ8Ce0c35T24ZXRx+TS44k9tpS3wyk2CQS4k3GdQKOKNAfJN+WQL3pdq7/
         NH6oZqcORsiFGl/dBAq9PFXU6jb4NgLKD35kghmb62bdSh6HydmN3jmEnvzMPEoTJi
         CCBYcZLvV2Dd6lvuYu79zDWzkFkM+E8AuDqn8drc0xdiSd5zxxNhYqHsbDM4nfLqQL
         zwtpabnJrDEUmS7VKryi6uj9+3uYwfE3926Y/1GmQML+Z+phq9mq+Eb4RSIzzXQVFI
         zBs0z09Y9cAMnoV3hhxqXjkIlzp71A9jctAB2W1CZladON1UaUV4VZyb94sxTPFhmp
         +psvjx/d2x7eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 44/50] kernel/power/energy_model.c: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:25 -0500
Message-Id: <20230303214531.1450154-44-sashal@kernel.org>
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

[ Upstream commit a0bc3f78d0fffa8be1a73bf945a43bfe1c2871c1 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Link: https://lore.kernel.org/r/20230202151515.2309543-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 97e62469a6b32..1b902f986f91c 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -85,10 +85,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.2

