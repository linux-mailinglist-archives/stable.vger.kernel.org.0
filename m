Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0C4594019
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiHOVIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241522AbiHOVEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:04:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC1D5710;
        Mon, 15 Aug 2022 12:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4E14CE1262;
        Mon, 15 Aug 2022 19:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D091EC433D6;
        Mon, 15 Aug 2022 19:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590889;
        bh=qLnXxGHuebqquUUuCDId5Q1nQL5MJHCqyFlJRxfHHtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSOKaNJqK0o6vUnInbs50pslSLCy8Zjfn4ltMRRp5FSNiLfpYflLGQgDDcF2Dr/F2
         qfY7r7oZzWNprygfw6CqHIIqtmc9T5owTTuYgbkrh/shf6B0VX7BsEi9eymq2/HgX6
         LJLGTZynz4RrecoDjD2aVAExv5tXv9o1+ioBCeG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0396/1095] drm/vc4: hdmi: Switch to pm_runtime_status_suspended
Date:   Mon, 15 Aug 2022 19:56:35 +0200
Message-Id: <20220815180446.070314409@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit fcef97e70094a33ded73b3eb9bef06698c6e9c12 ]

If the controller isn't clocked or its domain powered up, the register
accesses will either stall the CPU or return garbage, respectively.

Thus, we had a warning in our register access function to complain when
that kind of risky accesses were performed.

In order to check the runtime_pm power state, we were using
pm_runtime_active(), but it turns out that it will become active only
once the runtime_resume hook has been executed.

This prevents us from doing any WARN-free register access in our
runtime_resume() implementation, while this is valid.

Let's switch to pm_runtime_status_suspended() instead.

Fixes: 14e193b95604 ("drm/vc4: hdmi: Warn if we access the controller while disabled")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-23-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
index 24056441a4bb..72b769412482 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
@@ -417,7 +417,7 @@ static inline u32 vc4_hdmi_read(struct vc4_hdmi *hdmi,
 	const struct vc4_hdmi_variant *variant = hdmi->variant;
 	void __iomem *base;
 
-	WARN_ON(!pm_runtime_active(&hdmi->pdev->dev));
+	WARN_ON(pm_runtime_status_suspended(&hdmi->pdev->dev));
 
 	if (reg >= variant->num_registers) {
 		dev_warn(&hdmi->pdev->dev,
@@ -447,7 +447,7 @@ static inline void vc4_hdmi_write(struct vc4_hdmi *hdmi,
 
 	lockdep_assert_held(&hdmi->hw_lock);
 
-	WARN_ON(!pm_runtime_active(&hdmi->pdev->dev));
+	WARN_ON(pm_runtime_status_suspended(&hdmi->pdev->dev));
 
 	if (reg >= variant->num_registers) {
 		dev_warn(&hdmi->pdev->dev,
-- 
2.35.1



