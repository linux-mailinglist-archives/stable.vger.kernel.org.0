Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D33D65570A
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiLXBbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiLXBbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:31:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F62B2EFB8;
        Fri, 23 Dec 2022 17:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A310561FA3;
        Sat, 24 Dec 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABBC433F0;
        Sat, 24 Dec 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845414;
        bh=pQ9kLCTsb5EKb530KCcu7KaWdxbadgwvbpfzDbtxqrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRZazHd/vcZC9p9RNXUeQBugLWVgneHifmUYPhejZ6r+4xMDL+8jFI65UAfFgnyuy
         mvGsGocN2zDb6jOYiUm54qIxsOMGQHtuodfuZt4/AQkWO8KzzBgksvBX6gQcvt692d
         ewQr1JlbLwOdkGjaZucUw9okx6/fXfs6eaSJ1mq7VIpoqw0phv6SEjhBTur/iTiCmT
         kG6Wq20QXa8qoT2INOYnZeft1q35viSJCOUQOJLmek7QD/w8vEnaI2TzelVDYlVNNw
         88j+jorI9gLssbgec30eex/sScnU7tbVjzUbJWA+HX+THEZQqHQj7lr19XuoQyF0Vs
         AiwRNqvbxVpAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 14/26] devres: Use kmalloc_size_roundup() to match ksize() usage
Date:   Fri, 23 Dec 2022 20:29:18 -0500
Message-Id: <20221224012930.392358-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 6fcd7e702d3d91cc2c3194acffd7d67b2c10b81f ]

Round up allocations with kmalloc_size_roundup() so that devres's use
of ksize() is always accurate and no special handling of the memory is
needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221018090406.never.856-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 4ab2b50ee38f..c0e100074aa3 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -101,6 +101,9 @@ static bool check_dr_size(size_t size, size_t *tot_size)
 					size, tot_size)))
 		return false;
 
+	/* Actually allocate the full kmalloc bucket size. */
+	*tot_size = kmalloc_size_roundup(*tot_size);
+
 	return true;
 }
 
-- 
2.35.1

