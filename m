Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17802551E6A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350637AbiFTODc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350975AbiFTNx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B4721803;
        Mon, 20 Jun 2022 06:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ECF1B811CF;
        Mon, 20 Jun 2022 13:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11553C3411B;
        Mon, 20 Jun 2022 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731198;
        bh=uscibvU1dE4kaGunAQ0AXMp4l9bxe2ohEYSnU0LLu6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOLhwsFLIZE8Okmc/Kl5MGupyN5jDQ57kJpooS3nZUU+XfPiLmCAbqHpWRsJxTBqp
         zQVfBniRlURqdglVI4mplQAYDkaOFMMoUFoJ0pZeN75CBIp7yGXltFrlPG0iTOUW0I
         JSmuIqSFXILx8X9SZQa55jIEFoVu1teTEoi96Lsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/240] dma-debug: make things less spammy under memory pressure
Date:   Mon, 20 Jun 2022 14:51:24 +0200
Message-Id: <20220620124744.294871038@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1c133f610f59..9a4837b68e18 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -616,7 +616,7 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 
 	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
-		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
+		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	}
 
-- 
2.35.1



