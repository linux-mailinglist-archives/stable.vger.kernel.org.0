Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3FA6A7125
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCAQcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCAQcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:32:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D29497CD;
        Wed,  1 Mar 2023 08:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E897B810D1;
        Wed,  1 Mar 2023 16:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21AC43442;
        Wed,  1 Mar 2023 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688221;
        bh=mhLoWBLCvC+6LNIoKMHohw8KgtDwYWjT5FF61v3uLcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sw1KgNWQ8cmtn8G8LlbZ9WSUiuVamVPnXTOo8strl3MJcTfHxiNzXF8WC/k5bFHYw
         k6IT/B8H0kYeA7YTwjEhZqvtPQ/NJkGjnCyO9xb27k5OBZOKF1RkagzF+SlNF2KDE9
         6RxojfdxqzRTB0hnKIy65+OXze4O636YPZIoC85BdQv8G7/+MgGuqnkyAGI8mZUEdP
         1jkkDQr5N8DsFXEwBvDbBrwDlvjXPKEp4Z2fojwFELdKXuTI11uk7oXFvgoAciwxck
         fErZ00f2hxVvnpi+oRhb+bMPO8WQjTGtIlDK3PPh7vPU5NWekMdIldrtb9iXBMMv1s
         nSV3PBObOY2OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/3] efi: efivars: prevent double registration
Date:   Wed,  1 Mar 2023 11:30:16 -0500
Message-Id: <20230301163017.1303229-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301163017.1303229-1-sashal@kernel.org>
References: <20230301163017.1303229-1-sashal@kernel.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 0217a40d7ba6e71d7f3422fbe89b436e8ee7ece7 ]

Add the missing sanity check to efivars_register() so that it is no
longer possible to override an already registered set of efivar ops
(without first deregistering them).

This can help debug initialisation ordering issues where drivers have so
far unknowingly been relying on overriding the generic ops.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/vars.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index e619ced030d52..462e88b9d2ba4 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -1195,19 +1195,28 @@ int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject)
 {
+	int rv;
+
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
 
+	if (__efivars) {
+		pr_warn("efivars already registered\n");
+		rv = -EBUSY;
+		goto out;
+	}
+
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
 	__efivars = efivars;
 
 	pr_info("Registered efivars operations\n");
-
+	rv = 0;
+out:
 	up(&efivars_lock);
 
-	return 0;
+	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_register);
 
-- 
2.39.2

