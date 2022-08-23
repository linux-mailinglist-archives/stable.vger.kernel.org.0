Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE00259DDFB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbiHWL15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357718AbiHWL0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72578FD4A;
        Tue, 23 Aug 2022 02:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF5A9B81C65;
        Tue, 23 Aug 2022 09:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C99BC433C1;
        Tue, 23 Aug 2022 09:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246660;
        bh=MFsGsa/L5EH25NvlY8VLTWUP44zmEilNOLgSIGRY8SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1xjnTLfQtZnyOXY46vXSN8Zbn7d25v8rmVf4pjA1U0z0sSo2JBlALJSN7GNtpsba
         SaYS5wuiw8KCFTg8fo1WBSw5BVAfxkbEvoNX1u9ge+TRYN/8sr5+tOxaHR7PF5FV+s
         k2fP9zWb0sRNbmpPHRk+DQESYFtOTTWmvBR+2F0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/389] memstick/ms_block: Fix a memory leak
Date:   Tue, 23 Aug 2022 10:24:18 +0200
Message-Id: <20220823080123.157153426@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 54eb7a55be6779c4d0c25eaf5056498a28595049 ]

'erased_blocks_bitmap' is never freed. As it is allocated at the same time
as 'used_blocks_bitmap', it is likely that it should be freed also at the
same time.

Add the corresponding bitmap_free() in msb_data_clear().

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/b3b78926569445962ea5c3b6e9102418a9effb88.1656155715.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 399510585245..6014fcb49d7e 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1954,6 +1954,7 @@ static void msb_data_clear(struct msb_data *msb)
 {
 	kfree(msb->boot_page);
 	bitmap_free(msb->used_blocks_bitmap);
+	bitmap_free(msb->erased_blocks_bitmap);
 	kfree(msb->lba_to_pba_table);
 	kfree(msb->cache);
 	msb->card = NULL;
-- 
2.35.1



