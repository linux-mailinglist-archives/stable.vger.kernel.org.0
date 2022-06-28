Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4703455E13D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbiF1C0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244184AbiF1CYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:24:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCAF2529D;
        Mon, 27 Jun 2022 19:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B2BE6184B;
        Tue, 28 Jun 2022 02:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82387C341CA;
        Tue, 28 Jun 2022 02:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383016;
        bh=xqO4vp3dlvUVLT+/DOlPHPKaxANGbZMXg9bHo6VLcOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMmiUfEUQD88ZO9J4qlTOf7oA4AEaBcXB73hbMqo2/Lln5CtKVUfqnD9p5aaAi34f
         2eCMYgfF2guD7uQsu1DikoXEjRbHAQZtM5ZG9pquQ3MArrwlmuVkwJComtNosFYrNb
         Dy96ahz4vp74EclJl/6+mOQEo4uMzyHdwNbsh2vI3G/hCLbZYQ3Sw80d7FZWUE5scp
         TxB6mMZXEpUzJ33F+yIm+hjysDGTtwyhD9yA5UqNuGzDZwB7XtjeRM0iV48GbJkQn8
         NTrIupD3LqX6MnJnIsh19YJdF5dGS/sBP284EVZlLKIHvaN02uhWJHLo2qpemHO/sS
         t9dPzBWPWXJzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihao Han <hanyihao@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 19/34] video: fbdev: simplefb: Check before clk_put() not needed
Date:   Mon, 27 Jun 2022 22:22:26 -0400
Message-Id: <20220628022241.595835-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
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

From: Yihao Han <hanyihao@vivo.com>

[ Upstream commit 5491424d17bdeb7b7852a59367858251783f8398 ]

clk_put() already checks the clk ptr using !clk and IS_ERR()
so there is no need to check it again before calling it.

Signed-off-by: Yihao Han <hanyihao@vivo.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/simplefb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 533a047d07a2..85cfda4f4cf8 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -225,8 +225,7 @@ static int simplefb_clocks_get(struct simplefb_par *par,
 		if (IS_ERR(clock)) {
 			if (PTR_ERR(clock) == -EPROBE_DEFER) {
 				while (--i >= 0) {
-					if (par->clks[i])
-						clk_put(par->clks[i]);
+					clk_put(par->clks[i]);
 				}
 				kfree(par->clks);
 				return -EPROBE_DEFER;
-- 
2.35.1

