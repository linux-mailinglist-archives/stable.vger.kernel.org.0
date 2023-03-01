Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0091B6A70F1
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCAQ3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjCAQ3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:29:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147FF4392A;
        Wed,  1 Mar 2023 08:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3FDEB810BC;
        Wed,  1 Mar 2023 16:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BFBC433D2;
        Wed,  1 Mar 2023 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688182;
        bh=MttCeZaMeWac+EprNP+8yEYCyC/GUoPs7SWmMy6dFDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjZSyT5HcFHaLiXLdf+7dooBBpya9s1KKCvkeTHpQC4IzpAiTbD5Dr0f0WAPVU3U0
         YRiFecYhaUq+WM917PtRB5PrvWm7L8fUldoL70PUkpwcDqzrkpAk83aiBH5auTQ7DC
         hfWbbj5GlTQ4N6a11HhKl8P1WMJyp7TuBEGHL6ZfdaG1cRiVOETYteqFQUzjuy7YiT
         TF/Hd5Qjsdbuj9t5r5Cvzuc5YKBUUd/YrYg1Mh4Xwq5t4reUgv1nTxbRHKUzYBk6ME
         zpFlH1vynt/Y4UU/ap5Z7KA/MXsYn3VFriXkRy2sWPqmkkvWVFmJxoIq1ScOM22Jiv
         TWxLsxnNTWR4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 2/6] efi: efivars: prevent double registration
Date:   Wed,  1 Mar 2023 11:29:34 -0500
Message-Id: <20230301162938.1302886-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162938.1302886-1-sashal@kernel.org>
References: <20230301162938.1302886-1-sashal@kernel.org>
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

