Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09E75938C6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243568AbiHOSdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiHOScZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EA333A27;
        Mon, 15 Aug 2022 11:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F9360F1D;
        Mon, 15 Aug 2022 18:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD930C433C1;
        Mon, 15 Aug 2022 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587691;
        bh=S0URyn00AsjmOCVSf0xzz3DBx1yha/NWx8pddDfWzRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElkqmxlXEHZZ/P0Y5szVgTBU7lH2dYoiI0NGVHDxSbNvrXNnrv/G18ESNBzLKMwhs
         mn5CWSuCguy1jquzXpG1Rf5T9CDAN5smFA0YiK9vpLaoc1Qbgz1NLWPESpG2jHGvia
         CsCIhdalkh4xrUKwr4SykaOFSvRzhlLP4CKu12NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/779] soc: amlogic: Fix refcount leak in meson-secure-pwrc.c
Date:   Mon, 15 Aug 2022 19:56:49 +0200
Message-Id: <20220815180344.375939543@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit d18529a4c12f66d83daac78045ea54063bd43257 ]

In meson_secure_pwrc_probe(), there is a refcount leak in one fail
path.

Signed-off-by: Liang He <windhl@126.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Fixes: b3dde5013e13 ("soc: amlogic: Add support for Secure power domains controller")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220616144915.3988071-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-secure-pwrc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/amlogic/meson-secure-pwrc.c b/drivers/soc/amlogic/meson-secure-pwrc.c
index 59bd195fa9c9..2eeea5e1b3b7 100644
--- a/drivers/soc/amlogic/meson-secure-pwrc.c
+++ b/drivers/soc/amlogic/meson-secure-pwrc.c
@@ -139,8 +139,10 @@ static int meson_secure_pwrc_probe(struct platform_device *pdev)
 	}
 
 	pwrc = devm_kzalloc(&pdev->dev, sizeof(*pwrc), GFP_KERNEL);
-	if (!pwrc)
+	if (!pwrc) {
+		of_node_put(sm_np);
 		return -ENOMEM;
+	}
 
 	pwrc->fw = meson_sm_get(sm_np);
 	of_node_put(sm_np);
-- 
2.35.1



