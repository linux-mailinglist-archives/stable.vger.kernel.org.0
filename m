Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD65D5AEC2E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiIFOMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiIFOKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:10:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C9D86FD5;
        Tue,  6 Sep 2022 06:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F2161545;
        Tue,  6 Sep 2022 13:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25770C433D7;
        Tue,  6 Sep 2022 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471934;
        bh=k6UwijUgcLuNRyqCBHFlNPlazW0F3BbLsT++0iS51VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoQmupCqG1idzIuL65k6Xz3Rnw0kiXO0MVxCgPbJEzDvzfhDkUWD0a5qrT360bqSy
         xKtWGVRSGyuOSRGOzoDamhY2ax5sbxuryuH17O5H0OUGWaCxBkLWvFmcoDB8jUr7DQ
         sUmjsT5lqz7a3mmd93z3qaTcPVivNC6iH+uBPT5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 089/155] clk: core: Fix runtime PM sequence in clk_core_unprepare()
Date:   Tue,  6 Sep 2022 15:30:37 +0200
Message-Id: <20220906132833.203453064@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 4b592061f7b3971c70e8b72fc42aaead47c24701 ]

In the original commit 9a34b45397e5 ("clk: Add support for runtime PM"),
the commit message mentioned that pm_runtime_put_sync() would be done
at the end of clk_core_unprepare(). This mirrors the operations in
clk_core_prepare() in the opposite order.

However, the actual code that was added wasn't in the order the commit
message described. Move clk_pm_runtime_put() to the end of
clk_core_unprepare() so that it is in the correct order.

Fixes: 9a34b45397e5 ("clk: Add support for runtime PM")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220822081424.1310926-3-wenst@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f00d4c1158d72..f246d66f8261f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -840,10 +840,9 @@ static void clk_core_unprepare(struct clk_core *core)
 	if (core->ops->unprepare)
 		core->ops->unprepare(core->hw);
 
-	clk_pm_runtime_put(core);
-
 	trace_clk_unprepare_complete(core);
 	clk_core_unprepare(core->parent);
+	clk_pm_runtime_put(core);
 }
 
 static void clk_core_unprepare_lock(struct clk_core *core)
-- 
2.35.1



