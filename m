Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2815AEAD3
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbiIFNuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239140AbiIFNtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9604C10FD7;
        Tue,  6 Sep 2022 06:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D2361545;
        Tue,  6 Sep 2022 13:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69538C433C1;
        Tue,  6 Sep 2022 13:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471517;
        bh=gWFC3UEwVWJYUsSVYb540iYzjm8Ght+yh+I86oya6EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsr5a0YeFEyznxjeU70mHXcYk11mGKs8aQIBGLJhtO0eHkyKIlcZSRjPieiJntmlP
         7jDyPIBsWSZZnYmv6UTe2f8RGYpIh85koA6MwAP/jEz5pedgmOcfSMpx2HocHazB7c
         8s4vHGI0DdybHFmqeOhZz4/dsZK2jYvylXqf7iPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/107] clk: core: Fix runtime PM sequence in clk_core_unprepare()
Date:   Tue,  6 Sep 2022 15:30:34 +0200
Message-Id: <20220906132824.083353942@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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
index d6dc58bd07b33..0674dbc62eb55 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -846,10 +846,9 @@ static void clk_core_unprepare(struct clk_core *core)
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



