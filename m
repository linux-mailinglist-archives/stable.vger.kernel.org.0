Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653FA608774
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiJVIBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiJVIAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876332670E7;
        Sat, 22 Oct 2022 00:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95276092A;
        Sat, 22 Oct 2022 07:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98645C433C1;
        Sat, 22 Oct 2022 07:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424928;
        bh=phSnUqnY7Kv4or2QaTwjWCnYha4ABTmtG8iuKHhbVc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rleCEOgD592SzoCgauYcseqt2AX0DcYo0TWJ61G2jm+n6S7tAcdO3foLjLMhZu2Du
         IqyFII2/WID2jootnTYPlrVDOgo/f2JRPg41dWMiLDzbek/uoqooJbbYsXGKB+Q7Lj
         En8I2etcMLmQ6YKG7avpxIo4gifTjJ2ETz2bZnuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pin-Yen Lin <treapking@chromium.org>,
        Allen Chen <allen.chen@ite.com.tw>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 299/717] drm/bridge: it6505: Power on downstream device in .atomic_enable
Date:   Sat, 22 Oct 2022 09:22:58 +0200
Message-Id: <20221022072505.851111038@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-Yen Lin <treapking@chromium.org>

[ Upstream commit fbc1fdaa8338ec4ebd862d918a0ce3e12033e8a3 ]

Send DPCD DP_SET_POWER_D0 command to the monitor in .atomic_enable
callback. Without this command, some monitors won't show up again after
changing the resolution.

Fixes: 46ca7da7f1e8 ("drm/bridge: it6505: Send DPCD SET_POWER to downstream")

Signed-off-by: Pin-Yen Lin <treapking@chromium.org>
Reviewed-by: Allen Chen <allen.chen@ite.com.tw>
Fixes: 46ca7da7f1e8 ("drm/bridge: it6505: Send DPCD SET_POWER to downstream")
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220714173715.v2.1.I85af54e9ceda74ec69f661852825845f983fc343@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 4b673c4792d7..e5626035f311 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2945,6 +2945,9 @@ static void it6505_bridge_atomic_enable(struct drm_bridge *bridge,
 	if (ret)
 		dev_err(dev, "Failed to setup AVI infoframe: %d", ret);
 
+	it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
+				     DP_SET_POWER_D0);
+
 	it6505_update_video_parameter(it6505, mode);
 
 	ret = it6505_send_video_infoframe(it6505, &frame);
-- 
2.35.1



