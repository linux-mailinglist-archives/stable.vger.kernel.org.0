Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D35541A70
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379776AbiFGVdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380955AbiFGVb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C42C22C47B;
        Tue,  7 Jun 2022 12:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 441B6B8220B;
        Tue,  7 Jun 2022 19:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84085C385A2;
        Tue,  7 Jun 2022 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628620;
        bh=zvkWQXaxftvOIUbrHG5XsPOlAGPZGXkzs+x/ENuSNts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be3jRuZuvF8dvYYaB3yifgK560hvfV4wgQjxkiYEQF1ZPEfELljvYCriyPj4CcVBB
         RzNmMEr9KOZh3rpGBOMdmA5dS4s/GWir4MEyge8bFMxoZiqYAyc3DHixkg3B6010HT
         uot4Nn9nvYi2FGJ6zuttr+YSzDqtCXRIYeQP7YaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 395/879] ACPI: AGDI: Fix missing prototype warning for acpi_agdi_init()
Date:   Tue,  7 Jun 2022 18:58:33 +0200
Message-Id: <20220607165014.329272037@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 988d7a14408db4183202f16bb02b8149b9da3727 ]

When building with W=1, we get the following warning:

drivers/acpi/arm64/agdi.c:88:13: warning: no previous prototype for ‘acpi_agdi_init’ [-Wmissing-prototypes]
 void __init acpi_agdi_init(void)

Include AGDI driver's header file to pull in the prototype definition
for acpi_agdi_init() to get rid of the compiler warning

Fixes: a2a591fb76e6 ("ACPI: AGDI: Add driver for Arm Generic Diagnostic Dump and Reset device")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/agdi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/arm64/agdi.c b/drivers/acpi/arm64/agdi.c
index 4df337d545b7..cf31abd0ed1b 100644
--- a/drivers/acpi/arm64/agdi.c
+++ b/drivers/acpi/arm64/agdi.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) "ACPI: AGDI: " fmt
 
 #include <linux/acpi.h>
+#include <linux/acpi_agdi.h>
 #include <linux/arm_sdei.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-- 
2.35.1



