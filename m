Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3B4CF71C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiCGJoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbiCGJl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAC96252;
        Mon,  7 Mar 2022 01:40:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B73E611D5;
        Mon,  7 Mar 2022 09:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BCDC340F3;
        Mon,  7 Mar 2022 09:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646049;
        bh=Lc8jc0mvjGKkI5mWqYol9JlaBHGpE0J/ZnEnk/UGLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoKQpEghJ5iLiZtg8DzsvbZq3XaQ/RcawjIolPv13VTJk8sJQhpBZQikjaNU45IQH
         3b9RJzSFcHiyhcclPk2S6DqUg9+0+CoyQ5jO8eKYg4X5W9K5GuLxZ3lkCv3VZJO/ZM
         C6FfSwUrK9a1/d3RFxJMxCQa0BxvYMBVVdsmrHDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Marek Vasut <marex@denx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/262] drm: mxsfb: Fix NULL pointer dereference
Date:   Mon,  7 Mar 2022 10:17:40 +0100
Message-Id: <20220307091705.741630517@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 622c9a3a7868e1eeca39c55305ca3ebec4742b64 ]

mxsfb should not ever dereference the NULL pointer which
drm_atomic_get_new_bridge_state is allowed to return.
Assume a fixed format instead.

Fixes: b776b0f00f24 ("drm: mxsfb: Use bus_format from the nearest bridge if present")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202081755.145716-3-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_kms.c b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
index b96ba348c68d9..988bc4fbd78df 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -361,7 +361,11 @@ static void mxsfb_crtc_atomic_enable(struct drm_crtc *crtc,
 		bridge_state =
 			drm_atomic_get_new_bridge_state(state,
 							mxsfb->bridge);
-		bus_format = bridge_state->input_bus_cfg.format;
+		if (!bridge_state)
+			bus_format = MEDIA_BUS_FMT_FIXED;
+		else
+			bus_format = bridge_state->input_bus_cfg.format;
+
 		if (bus_format == MEDIA_BUS_FMT_FIXED) {
 			dev_warn_once(drm->dev,
 				      "Bridge does not provide bus format, assuming MEDIA_BUS_FMT_RGB888_1X24.\n"
-- 
2.34.1



