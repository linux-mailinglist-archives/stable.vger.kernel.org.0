Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6794F55C953
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiF0Lnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbiF0Lmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CCD131;
        Mon, 27 Jun 2022 04:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93BDDB81123;
        Mon, 27 Jun 2022 11:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858BC3411D;
        Mon, 27 Jun 2022 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329871;
        bh=wVLdpTvzq4nn+YD/fTY4xJ31uZESHMWQlhJpXrVSYgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpDho/PO0x1Jc3KAFpm81a9tzG5n8xl3qeF94SVTGiF1FaPtQt81TY0DyKjyfKVZ1
         XN6efIH2fMyd+vJKe+vVPSib6MZOfBSMjWSYrKWbET6hWOgC9ekm8b9n006hZZzHc7
         fOK4UEK6ITVy3pgwtSjkwb79UhlAUzgPijmZqV44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 5.15 120/135] drm/msm/dp: Always clear mask bits to disable interrupts at dp_ctrl_reset_irq_ctrl()
Date:   Mon, 27 Jun 2022 13:22:07 +0200
Message-Id: <20220627111941.637551823@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

commit 993a2adc6e2e94a0a7b5bfc054eda90ac95f62c3 upstream.

dp_catalog_ctrl_reset() will software reset DP controller. But it will
not reset programmable registers to default value. DP driver still have
to clear mask bits to interrupt status registers to disable interrupts
after software reset of controller.

At current implementation, dp_ctrl_reset_irq_ctrl() will software reset dp
controller but did not call dp_catalog_ctrl_enable_irq(false) to clear hpd
related interrupt mask bits to disable hpd related interrupts due to it
mistakenly think hpd related interrupt mask bits will be cleared by software
reset of dp controller automatically. This mistake may cause system to crash
during suspending procedure due to unexpected irq fired and trigger event
thread to access dp controller registers with controller clocks are disabled.

This patch fixes system crash during suspending problem by removing "enable"
flag condition checking at dp_ctrl_reset_irq_ctrl() so that hpd related
interrupt mask bits are cleared to prevent unexpected from happening.

Changes in v2:
-- add more details commit text

Changes in v3:
-- add synchrons_irq()
-- add atomic_t suspended

Changes in v4:
-- correct Fixes's commit ID
-- remove synchrons_irq()

Changes in v5:
-- revise commit text

Changes in v6:
-- add event_lock to protect "suspended"

Changes in v7:
-- delete "suspended" flag

Fixes: 989ebe7bc446 ("drm/msm/dp: do not initialize phy until plugin interrupt received")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/486591/
Link: https://lore.kernel.org/r/1652804494-19650-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1356,8 +1356,13 @@ void dp_ctrl_reset_irq_ctrl(struct dp_ct
 
 	dp_catalog_ctrl_reset(ctrl->catalog);
 
-	if (enable)
-		dp_catalog_ctrl_enable_irq(ctrl->catalog, enable);
+	/*
+	 * all dp controller programmable registers will not
+	 * be reset to default value after DP_SW_RESET
+	 * therefore interrupt mask bits have to be updated
+	 * to enable/disable interrupts
+	 */
+	dp_catalog_ctrl_enable_irq(ctrl->catalog, enable);
 }
 
 void dp_ctrl_phy_init(struct dp_ctrl *dp_ctrl)


