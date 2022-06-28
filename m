Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA355D689
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243982AbiF1CXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243979AbiF1CWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EF524962;
        Mon, 27 Jun 2022 19:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D6B5B81C0A;
        Tue, 28 Jun 2022 02:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F116C341CA;
        Tue, 28 Jun 2022 02:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382922;
        bh=5Z8NJZbbbrYzyBpM85p3FG17A+TL/aFVzy58DotQXlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uI+WOvyEfPmc1Xr1VNQJrksWWfrjYba3U23BaZ/3xd7oOV+4yyu9dvvA1t15PuP5v
         up2ZIucJb5DUnUYZMVQ07QztJk4EBwIBXWALnTFOuYyi9WxSBvc2+c1OTKeYzsvUHL
         FV1wGHMphgEy3Yn2MePuknI4E86smo4e0fHBJZ9aOxXhvL8rBzMIkeN9KEjRjnJ031
         yj83rFZh592r3YPoLjgkNUr1Gu4J7CQSPnKUA1OwLQ5Wk0eUgYAlnav8cRSYu93EiG
         eV6XYE8fsE014LXEIqxb6msnIBt3DwWS9XbuRDB/Rcz3tXQ8HR4w9Wt6GN5f09X0H/
         dPxce5Mf+P4dQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihao Han <hanyihao@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 23/41] video: fbdev: simplefb: Check before clk_put() not needed
Date:   Mon, 27 Jun 2022 22:20:42 -0400
Message-Id: <20220628022100.595243-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
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
index a2e3a4690025..c615b7ec59c9 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -231,8 +231,7 @@ static int simplefb_clocks_get(struct simplefb_par *par,
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

