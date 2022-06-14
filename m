Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B350554A573
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353159AbiFNCP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354030AbiFNCOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8B3B2AB;
        Mon, 13 Jun 2022 19:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 338E8B816BB;
        Tue, 14 Jun 2022 02:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C7C36AFE;
        Tue, 14 Jun 2022 02:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172501;
        bh=Zzb5/gr7v+HM61U+99KSrd0cawCpe1xPsCdEb4c6n2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQT7QPvqsFfxj9oQGvj6bznGfcdzrQMrdYP4gDzHui6w1+mKHK8d3zP3DcE1j3ao2
         luzNHidsMiLVCCT9HMTLmP83qsPczGJhqsHQgT39z45AVfnot0Sz6aNe7xD1yzel9C
         Pjj6QMMAqVV2iFeeLxlmVyr/WZbko3DCme5EDC/cu0VrkwsuHDJbDIgKlfMs8OIths
         sTt3ItxDyrXkEYhVEx9s8NAbNbUQYwPbmLwgg+TjJRL4LkLff6R8qvLNb29894y1aV
         bOUOILPVAMuRg15d6TWZg3qx5L/hqXdB9BjZb3DY9cbR1srM4mlS0Kk9OpZ1d/p/oR
         Nqx85SZlFXY7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 03/29] dma-debug: make things less spammy under memory pressure
Date:   Mon, 13 Jun 2022 22:07:49 -0400
Message-Id: <20220614020815.1099999-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
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
index ee7da1f2462f..ae9fc1ee6d20 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -564,7 +564,7 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 
 	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
-		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
+		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	}
 
-- 
2.35.1

