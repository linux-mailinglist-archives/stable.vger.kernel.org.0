Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140CE5FCF62
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJMARp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJMARY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261E1504B1;
        Wed, 12 Oct 2022 17:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 035B6616B5;
        Thu, 13 Oct 2022 00:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71390C433C1;
        Thu, 13 Oct 2022 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620204;
        bh=WRtqGp2RhVixJUo25HMBr+5XkUxZeBRE9AVgUAtxqb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Od4hR/e1rcazRT5ISx0098gNqui/MjHj+gUp2l0gH7Zamdpm8ProUdjl1CbDc65bZ
         TaFqDKPAEvkfSU6hcCqWVdCyINLtC4Edh6OqTUYPEE7Bnf+yiYyN0ayH9cDcI8rn8Z
         W7RNHv4TmUUsAKvuSWtIq6VYaxvZH03d9+jUrpnMwCocdiytOXvw4vO9F1eQCBpG1e
         sZIi4q4Il06Y4hg90rxzjFHupCm5HSzL6GedFuSDE527kD04GJPytqUw/ShKOzzHk0
         QU4TFc6Sz3kBA09CPtbZYm9LtX0Q1yVzndSRfaIsUfjksyUWPnePQRTE4ToJvxdj9f
         Eu1e9owg/p/vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nam Cao <namcaov@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, forest@alittletooquiet.net,
        tomm.merciai@gmail.com, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 18/67] staging: vt6655: fix potential memory leak
Date:   Wed, 12 Oct 2022 20:14:59 -0400
Message-Id: <20221013001554.1892206-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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
index bab08a40fe66..7d9a4000bc13 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -694,7 +694,7 @@ static int device_init_td0_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD0Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1

