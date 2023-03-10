Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F006B41CA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCJN4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjCJN4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2F710FBBC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19BAD617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0FAC433EF;
        Fri, 10 Mar 2023 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456570;
        bh=BtpRRmAwmp+wle9T2F+1zMPKEBYiOKFCztRZkmdwxY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnZX29Nl2HMA3Pql0YQYZjYvhswTTv4vFXXnIP1arZ5HSaGZm2z+nMNh87jYBY8Hw
         fboerDP53AF+gS2xTAmNt2r5kwZM6/vcl3egldvBak4aAW7LLIAArnpyVcHB1OR1vi
         GertKBxsqpj6629MiC7zoCngDkWzAhjNvYbmoLiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roger Lu <roger.lu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 018/211] soc: mediatek: mtk-svs: reset svs when svs_resume() fail
Date:   Fri, 10 Mar 2023 14:36:38 +0100
Message-Id: <20230310133719.290234390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit f4f8ad204a15d57c1a3e8ea7eca62157b44cbf59 ]

Add svs reset when svs_resume() fail.

Fixes: a825d72f74a3 ("soc: mediatek: fix missing clk_disable_unprepare() on err in svs_resume()")
Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-3-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 9859e6cf6b8f9..e0b8aa75c84b6 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1614,12 +1614,16 @@ static int svs_resume(struct device *dev)
 
 	ret = svs_init02(svsp);
 	if (ret)
-		goto out_of_resume;
+		goto svs_resume_reset_assert;
 
 	svs_mon_mode(svsp);
 
 	return 0;
 
+svs_resume_reset_assert:
+	dev_err(svsp->dev, "assert reset: %d\n",
+		reset_control_assert(svsp->rst));
+
 out_of_resume:
 	clk_disable_unprepare(svsp->main_clk);
 	return ret;
-- 
2.39.2



