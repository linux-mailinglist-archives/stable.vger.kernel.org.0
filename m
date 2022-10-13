Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C25FD0DF
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiJMAaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiJMA2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:28:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0216AB603E;
        Wed, 12 Oct 2022 17:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D461B81CD3;
        Thu, 13 Oct 2022 00:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B96C433D6;
        Thu, 13 Oct 2022 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620734;
        bh=PiQtHSyS109dp8Ihf4mpZ16gBG84L3RHgJLTXCa83aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASezIC7bt9pGzG7YExWXLd7LM+G3yVYCZrJu5rZ7fFoxGouJZpUItz3FbCdXZ2jn6
         BiEmI1iTkxe/OK9VGhI11QuCITcw9iS8/TAxEVa6GhGwY6vP7ld3XQ7VApQuvuezu3
         2uL9WuXg3nM3Fo8zdyaUJ4gOOBJfVI1uKp66WAeWUAxrinLSzpBmLcN4GmAVl89BI/
         22/ct+fcqf2ARDacIXxm/eWqiV9b1v6007uONuQZ5hsJob8f+R2SHRs7+9uUD/yb9/
         0J5bjPYRB3gjag0jhjjJW4JOH5tNMqqp1OgWam+4lCy6DzBu3MFzXknRJe6ysZRf01
         nFFJQf2+V6T3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nam Cao <namcaov@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, forest@alittletooquiet.net,
        tomm.merciai@gmail.com, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 09/27] staging: vt6655: fix potential memory leak
Date:   Wed, 12 Oct 2022 20:24:41 -0400
Message-Id: <20221013002501.1895204-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002501.1895204-1-sashal@kernel.org>
References: <20221013002501.1895204-1-sashal@kernel.org>
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

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit c8ff91535880d41b49699b3829fb6151942de29e ]

In function device_init_td0_ring, memory is allocated for member
td_info of priv->apTD0Rings[i], with i increasing from 0. In case of
allocation failure, the memory is freed in reversed order, with i
decreasing to 0. However, the case i=0 is left out and thus memory is
leaked.

Modify the memory freeing loop to include the case i=0.

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Signed-off-by: Nam Cao <namcaov@gmail.com>
Link: https://lore.kernel.org/r/20220909141338.19343-1-namcaov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 082302944c37..02bf33ace1eb 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -670,7 +670,7 @@ static int device_init_td0_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD0Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1

