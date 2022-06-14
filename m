Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B1C54A518
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352649AbiFNCNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352539AbiFNCMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:12:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEB17596;
        Mon, 13 Jun 2022 19:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0CA6B80AC1;
        Tue, 14 Jun 2022 02:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD11C34114;
        Tue, 14 Jun 2022 02:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172439;
        bh=jpahqU4Ez2Jv2ovq+6xWJVXthFohCC2sf6mGPWztRhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0j9b49Ja7wcms9V3Xuptm0ETSIGX+XAUYocEy+HDdKDElB8Vj/RoWWBlLhCSK0a1
         KDEAAyLK6fvATD+gQJi6T8NJ+vAHoTWF/iRqEflD72LcXJvUIeWGFgpzQblAxCOtmy
         OrPdU61qkIMi5qlNJEVocuFRYJ9mN0XnzhsH+6I8Xkba/8CzWJoLzTBhkOHfFAOpb8
         bm/TfDCk1jV1561V7hMe5K5YrcpW4aqRVkwvglCitY6C3iCL7jjZg/Cr+qsArWSedQ
         4po/QBCkUDzRsbPxBkWds2XleDspLwNq9oZALj6OLscc6Prb6G0QOuBf5Nmx1/vd0H
         wk4K0M5gSQYhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 06/41] dma-debug: make things less spammy under memory pressure
Date:   Mon, 13 Jun 2022 22:06:31 -0400
Message-Id: <20220614020707.1099487-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020707.1099487-1-sashal@kernel.org>
References: <20220614020707.1099487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit e19f8fa6ce1ca9b8b934ba7d2e8f34c95abc6e60 ]

Limit the error msg to avoid flooding the console.  If you have a lot of
threads hitting this at once, they could have already gotten passed the
dma_debug_disabled() check before they get to the point of allocation
failure, resulting in quite a lot of this error message spamming the
log.  Use pr_err_once() to limit that.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index ac740630c79c..2caafd13f8aa 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -564,7 +564,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 
 	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
-		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
+		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		err_printk(entry->dev, entry,
-- 
2.35.1

