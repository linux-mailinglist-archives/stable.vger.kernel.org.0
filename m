Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E876A70E5
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCAQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCAQ3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01091ACC5;
        Wed,  1 Mar 2023 08:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 717E5B810B9;
        Wed,  1 Mar 2023 16:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74550C433D2;
        Wed,  1 Mar 2023 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688173;
        bh=MttCeZaMeWac+EprNP+8yEYCyC/GUoPs7SWmMy6dFDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oueZbcbX1N54dXtFrDlQEb/oCiJnbWGpo3O3ZHTao/SrOYMlmyGy8yqjcyn5XGGeJ
         Ntr81Xn8eXvUWIyCScNijwkk1UFjbMyUWD/xmFSqsQjywGSP35/f61bf0h2Id3c0Iy
         4TwZZbX4O5nlvoBed7NlXg4m1thn3yDczRKP89gIc93H3pOrDjqiGCUhQ0aW5CeY9H
         n9pticDM8JXp/1BrTrYbFzD2ORVyc4miC4reY9XeQ7YOUAHA2Q1uur3oSbXOncjw73
         lEsztWEWvGVVe/JNmWMZtKmlORJYPcC72XzusKZ0O23af+t+PFPAQ7b6MxNfVSL7Ef
         5MgB3ObkY0URw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 2/6] efi: efivars: prevent double registration
Date:   Wed,  1 Mar 2023 11:29:25 -0500
Message-Id: <20230301162929.1302785-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162929.1302785-1-sashal@kernel.org>
References: <20230301162929.1302785-1-sashal@kernel.org>
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
index 0ba9f18312f5b..4ca256bcd6971 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -66,19 +66,28 @@ int efivars_register(struct efivars *efivars,
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

