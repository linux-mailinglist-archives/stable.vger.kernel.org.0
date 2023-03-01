Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAD6A710F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCAQa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCAQa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A705A497E2;
        Wed,  1 Mar 2023 08:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B40B810C5;
        Wed,  1 Mar 2023 16:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FFDC433A1;
        Wed,  1 Mar 2023 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688201;
        bh=G3JfbTsNi23rXEdWg0lTtz3JCcDgM3Hn0d9MSJ5QCvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFlnrLVv2XkorGI1H+VYWXtcxIpW9A4ugxKxqtYh9AEprNKMlfzZ0DUJn7JHIL9qY
         Gn7ZEiUDynvTt+wGBtmIS+qBAOTytREWqPRr8UdHQ/EMhlTNAue/ApmUY0WIhCsWp7
         wJBQdvYGI/l9VOrZ+ZEQw9BqkICQGWYOpRF45vzwfRpdds6EcosjlFMym4yqMxBQEi
         svOFr1grTGo9EzJhGm6pfbR9FQBrcvFfbx9hyp4Uo2h90pbpJtCWCbYrBo3GzzHD4f
         E7jGidcM5PIFmf4/ZAll6nz2BvgOs14GBbNUPvATFRD2igtNiPVsx8WWfinGAB5ZLQ
         D4R6y0BmOeJ4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/5] efi: efivars: prevent double registration
Date:   Wed,  1 Mar 2023 11:29:54 -0500
Message-Id: <20230301162957.1303086-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162957.1303086-1-sashal@kernel.org>
References: <20230301162957.1303086-1-sashal@kernel.org>
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
index cae590bd08f27..871dee9343bfb 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -1164,19 +1164,28 @@ int efivars_register(struct efivars *efivars,
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

