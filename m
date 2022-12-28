Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45406658152
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiL1Q1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiL1Q0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:26:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82CB1CB23
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC3C16157B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B4C433EF;
        Wed, 28 Dec 2022 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244585;
        bh=pdwzA/XoapmHU5irxCEgo+Z4pa0eAfYtYmmYKkeQ51o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jVbpjOQcUEhLZK3cuPaafDj2/UjqiTOEiizMncGmK3qpclUMN/QJbwCuoBFbjrAT
         lqxvPuhRdDtvkKpHdfeV09Ck4jCyPtuN4mvpJweVbzcwgbcunKVYth41/ck5F2V/9i
         nhRIAxDCPmCDIik6EMpsLugSCFD20Lnv34f3HlkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0698/1146] staging: vme_user: Fix possible UAF in tsi148_dma_list_add
Date:   Wed, 28 Dec 2022 15:37:17 +0100
Message-Id: <20221228144349.104057109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 357057ee55d3c99a5de5abe8150f7bca04f8e53b ]

Smatch report warning as follows:

drivers/staging/vme_user/vme_tsi148.c:1757 tsi148_dma_list_add() warn:
  '&entry->list' not removed from list

In tsi148_dma_list_add(), the error path "goto err_dma" will not
remove entry->list from list->entries, but entry will be freed,
then list traversal may cause UAF.

Fix by removeing it from list->entries before free().

Fixes: b2383c90a9d6 ("vme: tsi148: fix first DMA item mapping")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117035914.2954454-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vme_user/vme_tsi148.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vme_user/vme_tsi148.c b/drivers/staging/vme_user/vme_tsi148.c
index 020e0b3bce64..0171f46d1848 100644
--- a/drivers/staging/vme_user/vme_tsi148.c
+++ b/drivers/staging/vme_user/vme_tsi148.c
@@ -1751,6 +1751,7 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 	return 0;
 
 err_dma:
+	list_del(&entry->list);
 err_dest:
 err_source:
 err_align:
-- 
2.35.1



