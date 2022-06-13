Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B05554944D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbiFMKsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245081AbiFMKqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:46:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2639F2BB12;
        Mon, 13 Jun 2022 03:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40050B80E2D;
        Mon, 13 Jun 2022 10:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA338C34114;
        Mon, 13 Jun 2022 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115946;
        bh=ockDeXhQuJGhj3zJd/glicCCiwAoqKGOoVyrjVbqya4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDPm9Vua4uM/OuSjWW5brcSnzam8Yd6l9d12rnJNkXH+oZwzt8z6jR9ijuCadLX8I
         FFHkHJf0ZFnvg6UMb1aMsTLtcLcOrrK1UzMsNLnYTgROzvse/VGmRYJbulRYna/INl
         i9aPEqlufQLQTVvOkPcuKc3Hs/EhfxHisusFNmjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Ziegfeld" <dzigg@posteo.de>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/218] iommu/amd: Increase timeout waiting for GA log enablement
Date:   Mon, 13 Jun 2022 12:09:17 +0200
Message-Id: <20220613094923.552621398@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 42bb5aa043382f09bef2cc33b8431be867c70f8e ]

On some systems it can take a long time for the hardware to enable the
GA log of the AMD IOMMU. The current wait time is only 0.1ms, but
testing showed that it can take up to 14ms for the GA log to enter
running state after it has been enabled.

Sometimes the long delay happens when booting the system, sometimes
only on resume. Adjust the timeout accordingly to not print a warning
when hardware takes a longer than usual.

There has already been an attempt to fix this with commit

	9b45a7738eec ("iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()")

But that commit was based on some wrong math and did not fix the issue
in all cases.

Cc: "D. Ziegfeld" <dzigg@posteo.de>
Cc: Jörg-Volker Peetz <jvpeetz@web.de>
Fixes: 8bda0cfbdc1a ("iommu/amd: Detect and initialize guest vAPIC log")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220520102214.12563-1-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 5dddbb9b06f1..2a6a108f0e8c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -89,7 +89,7 @@
 #define ACPI_DEVFLAG_LINT1              0x80
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
-#define LOOP_TIMEOUT	100000
+#define LOOP_TIMEOUT	2000000
 /*
  * ACPI table definitions
  *
-- 
2.35.1



