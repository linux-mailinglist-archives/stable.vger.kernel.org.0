Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71E8599F68
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350881AbiHSQCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351194AbiHSQAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:00:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343EE109A26;
        Fri, 19 Aug 2022 08:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFDEB82819;
        Fri, 19 Aug 2022 15:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843BAC433C1;
        Fri, 19 Aug 2022 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924327;
        bh=JdOxDb19qhiS+BSMzr2+m+qw4SHjh6WSUT+IaLSa8dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3GW4zE4ufoZun1QiAPllTBNbXBRJgPvktLfgSceOoBP3rB45dCKe716FrnZI7Cda
         O/BkkMDW4NJMj83WFPYdP7tpBJNkvybSV26sOrTsVpuz2k/9fZmk0dB/iR8cE6Wy1L
         mMGuj4YxbBkqejNOgAlHu6MXoXbCnyHBPE2CyU/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/545] soc: amlogic: Fix refcount leak in meson-secure-pwrc.c
Date:   Fri, 19 Aug 2022 17:38:06 +0200
Message-Id: <20220819153834.483199617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 5fb29a475879..fff92e2f3974 100644
--- a/drivers/soc/amlogic/meson-secure-pwrc.c
+++ b/drivers/soc/amlogic/meson-secure-pwrc.c
@@ -138,8 +138,10 @@ static int meson_secure_pwrc_probe(struct platform_device *pdev)
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



