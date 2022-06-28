Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D260D55E130
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbiF1Ca4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244880AbiF1C2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF46D252B4;
        Mon, 27 Jun 2022 19:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE8C6192D;
        Tue, 28 Jun 2022 02:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3B7C341CA;
        Tue, 28 Jun 2022 02:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383235;
        bh=VttBdWDUBl9A3RqWXWoax22uYxYPC+6gtQNYnwCFaz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6LMcpc7hH0Nl+FZ6U9hMeJFp5fSLRrIby8pV2w++KjqKs1QyjDy0tNSBQpbayUaU
         luWO7eJcoo8z5NXyctqNaprOWOPdI/Nzl2qgjVopiHaLpQo2UmhX5TSnzA/YnGjKRp
         /Tftko6ayWWYb7V8r3CMO1F0B7WQEGj592BJDFAO6mpxwjjvL+sd4I1l2o+rdsIhtK
         wQIqI2raYFk3PgFzqR/BMRl1u5z2lVu6NpTAuqUS63tv5HGgc6bXlF/8Te7J32/pdI
         jVh4uw/0wxeZgkyhqxPmuZYbyC2sqX9wh1bBySkAXfCkOn/RtrJZxX/Za49jbTCbFG
         U6VesoVEfhGgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <imv4bel@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, yangyingliang@huawei.com,
        yang.lee@linux.alibaba.com, cai.huoqing@linux.dev,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 07/13] video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write
Date:   Mon, 27 Jun 2022 22:26:51 -0400
Message-Id: <20220628022657.597208-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022657.597208-1-sashal@kernel.org>
References: <20220628022657.597208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]

In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
type int.  Then, copy_from_user() may cause a heap overflow because it is used
as the third argument of copy_from_user().

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxa3xx-gcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 184773b6b9e4..2cca4b763d8d 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -391,7 +391,7 @@ pxa3xx_gcu_write(struct file *file, const char *buff,
 	struct pxa3xx_gcu_batch	*buffer;
 	struct pxa3xx_gcu_priv *priv = to_pxa3xx_gcu_priv(file);
 
-	int words = count / 4;
+	size_t words = count / 4;
 
 	/* Does not need to be atomic. There's a lock in user space,
 	 * but anyhow, this is just for statistics. */
-- 
2.35.1

