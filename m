Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35ED65C01FF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiIUPqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiIUPqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A167C75E;
        Wed, 21 Sep 2022 08:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61EEDB81D4E;
        Wed, 21 Sep 2022 15:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DBAC433C1;
        Wed, 21 Sep 2022 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775196;
        bh=FVu0qOm7anUZ1Ub0CCc959D/nFP+NEmD3sIKL4tT7Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=br69lf3EcidKLQtmGnpvVwIMf6Mzwz0EuQwAoxxooiWNgwINNVQpQpA2DyjPw9OYr
         qgTnXkpFnaH4ExikcrNpRZOZcLqwlSOnoR6az6md/vN9EnQy0ShrlVKlawBOg+GB7+
         3PZYYANHrx/WTIaDZ+QDQkUuLg4YccovIjnUdTE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 11/38] drm/panel-edp: Fix delays for Innolux N116BCA-EA1
Date:   Wed, 21 Sep 2022 17:45:55 +0200
Message-Id: <20220921153646.655164587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 8f7115c1923cd11146525f1615beb29018001964 ]

Commit 52824ca4502d ("drm/panel-edp: Better describe eDP panel delays")
clarified the various delays used for eDP panels, tying them to the eDP
panel timing diagram.

For Innolux N116BCA-EA1, .prepare_to_enable would be:

    t4_min + t5_min + t6_min + max(t7_max, t8_min)

Since t4_min and t5_min are both 0, the panel can use either .enable or
.prepare_to_enable.

As .enable is better defined, switch to using .enable for this panel.

Also add .disable = 50, based on the datasheet's t9_min value. This
effectively makes the delays the same as delay_200_500_e80_d50.

Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 51d35631c970 ("drm/panel-simple: Add N116BCA-EA1")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220908085454.1024167-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index a189982601a4..e8040defe607 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1270,7 +1270,8 @@ static const struct panel_desc innolux_n116bca_ea1 = {
 	},
 	.delay = {
 		.hpd_absent = 200,
-		.prepare_to_enable = 80,
+		.enable = 80,
+		.disable = 50,
 		.unprepare = 500,
 	},
 };
-- 
2.35.1



