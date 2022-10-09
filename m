Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843685F94DE
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiJJANT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiJJAMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6598E1A3B6;
        Sun,  9 Oct 2022 16:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DA6AB80DE4;
        Sun,  9 Oct 2022 23:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CEC433D7;
        Sun,  9 Oct 2022 23:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359396;
        bh=T//Mq0MV/vPrzN/kQ3SK6QnEFdooxLJ2GbtjTJnDnIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNr2Bl15ayFbrtmbyLoA4195TFEAaOwbCwRSa99sAWuj/mnSLR+UubaRMZqApQ17F
         pZdOkAyH1PlungTiSlVJr7xuaXIl6RsezHCsLtr5EHy0KMcXufl1fFENlF/6GiBLLR
         arS2q9NHDQErO+AMMUPKB0yiWWGV0gr6T5ldXzoweKGdUCYxFD9ik47EJCDPK1kvaB
         4Hdwfy7hB5sy1d+w5Qh5xXWGcB3UYjIxuxBBjWAM8T1XZZr91JxMLUMLiGZIdLCRDx
         KtXov1ZRK/C4i60m/IKDH0NBvj/FoVGf1udPN0ilZ5dMETSYpT+TngQBrQyNJvC6iM
         asJD1ptWdyS0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 10/44] platform/x86: pmc_atom: Improve quirk message to be less cryptic
Date:   Sun,  9 Oct 2022 19:48:58 -0400
Message-Id: <20221009234932.1230196-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 32c9b75640aeb1b144f9e2963c1640f4cef7c6f2 ]

Not everyone can get what "critclks" means in the message, improve
it to make less cryptic.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220801113734.36131-2-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index 5c757c7f64de..f4046572a9fe 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -354,7 +354,7 @@ static bool pmc_clk_is_critical = true;
 
 static int dmi_callback(const struct dmi_system_id *d)
 {
-	pr_info("%s critclks quirk enabled\n", d->ident);
+	pr_info("%s: PMC critical clocks quirk enabled\n", d->ident);
 
 	return 1;
 }
-- 
2.35.1

