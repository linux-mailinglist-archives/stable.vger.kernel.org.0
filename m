Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732665830AB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbiG0Rkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiG0Rjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:39:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347288CD7;
        Wed, 27 Jul 2022 09:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77791B821D4;
        Wed, 27 Jul 2022 16:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80A9C433C1;
        Wed, 27 Jul 2022 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940676;
        bh=q0JSE8ux2FV7K2RUeGZwHsCybUA+f+mNEP39HiD25Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DruJfRfxdpKh2/Op4i41nHsmNaPQEvY1YDOAyofr7exktP5QbB5QcyRpXONFxtOvO
         kPSfi8UI1jHazsyHnMLPWEn6UbEYRHH0qKlAQN+iztxUvsTATE16+r+uN/Xk5jjJW7
         OX+YHKzuX+wdZlVZQtBVg+jirgeuFG9Cr+f0ox2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 109/158] drm/panel-edp: Fix variable typo when saving hpd absent delay from DT
Date:   Wed, 27 Jul 2022 18:12:53 +0200
Message-Id: <20220727161025.849277072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit ef2084a8388b19c8812356106e0c8d29915f9d8b ]

The value read from the "hpd-absent-delay-ms" property in DT was being
saved to the wrong variable, overriding the hpd_reliable delay. Fix the
typo.

Fixes: 5540cf8f3e8d ("drm/panel-edp: Implement generic "edp-panel"s probed by EDID")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220719203857.1488831-4-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index f7bfcf63d48e..701a258d2e11 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -713,7 +713,7 @@ static int generic_edp_panel_probe(struct device *dev, struct panel_edp *panel)
 	of_property_read_u32(dev->of_node, "hpd-reliable-delay-ms", &reliable_ms);
 	desc->delay.hpd_reliable = reliable_ms;
 	of_property_read_u32(dev->of_node, "hpd-absent-delay-ms", &absent_ms);
-	desc->delay.hpd_reliable = absent_ms;
+	desc->delay.hpd_absent = absent_ms;
 
 	/* Power the panel on so we can read the EDID */
 	ret = pm_runtime_get_sync(dev);
-- 
2.35.1



