Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C9F54197D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377795AbiFGVW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380794AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B179C2982C;
        Tue,  7 Jun 2022 11:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E76EB8233E;
        Tue,  7 Jun 2022 18:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72C9C385A2;
        Tue,  7 Jun 2022 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628243;
        bh=l+KNCHbgVMmd/yIZZbjqm8gJi4yhr1wcah02wTfDYYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNV031xN9tKDoklMlydq2Q2J6KlmDYQn9609QGRwJfsCEZqlwCJAGa9E+UN2k+GPQ
         6yBSnWiPx2+0Ba58plVWGE9lEx9fvY3J3QbUWM5ghqbrFE3FZCubePZa1HTtm0nbRY
         6oodKPSgSLi/Pb1hHSHk5zCYnjO24cj0cl8z1prU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 258/879] drm/bridge: anx7625: check the return on anx7625_aux_trans
Date:   Tue,  7 Jun 2022 18:56:16 +0200
Message-Id: <20220607165010.338124319@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit d583e752732421b26fef0d65020565f3bef12248 ]

Clang static analysis reports this issue
anx7625.c:876:13: warning: The left operand of '&' is
  a garbage value
  if (!(bcap & 0xOA01)) {
        ~~~~ ^

bcap is only set by a successful call to
anx7625_aux_trans().  So check.

Fixes: cd1637c7e480 ("drm/bridge: anx7625: add HDCP support")
Signed-off-by: Tom Rix <trix@redhat.com>
Fixes: adca62ec370c ("drm/bridge: anx7625: Support reading edid through aux channel")
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220303201943.501746-1-trix@redhat.com
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 31ecf5626f1d..8e1851a57638 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -874,7 +874,10 @@ static int anx7625_hdcp_enable(struct anx7625_data *ctx)
 	}
 
 	/* Read downstream capability */
-	anx7625_aux_trans(ctx, DP_AUX_NATIVE_READ, 0x68028, 1, &bcap);
+	ret = anx7625_aux_trans(ctx, DP_AUX_NATIVE_READ, 0x68028, 1, &bcap);
+	if (ret < 0)
+		return ret;
+
 	if (!(bcap & 0x01)) {
 		pr_warn("downstream not support HDCP 1.4, cap(%x).\n", bcap);
 		return 0;
-- 
2.35.1



