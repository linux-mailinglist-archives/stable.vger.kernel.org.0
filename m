Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BFA66C4A7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjAPP5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjAPP4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F69B23C60
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A5461042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3197C433EF;
        Mon, 16 Jan 2023 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884600;
        bh=il4WES6RfhLkeAmz+y737Yhjarm804HuJpRP4XT7iOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEIyqviCJm0sZfj2v7DTJWr8HFGGFeRO8g0aDGsw9CNuG22lLMS1PfhzQI+k7snKO
         fpDqyRLkV7Oq9kiqkteeIw3awjKqOho6WI/W6VPV8VYoB8SX5lVNxIJ6+r/4hxr1Fb
         +Oj/yDv0CcKCAL/thL9f8dgL0j/qnjL0qk7KOMPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.1 066/183] drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer
Date:   Mon, 16 Jan 2023 16:49:49 +0100
Message-Id: <20230116154806.142643486@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

commit 1cba0d150fa102439114a91b3e215909efc9f169 upstream.

There are 3 possible interrupt sources are handled by DP controller,
HPDstatus, Controller state changes and Aux read/write transaction.
At every irq, DP controller have to check isr status of every interrupt
sources and service the interrupt if its isr status bits shows interrupts
are pending. There is potential race condition may happen at current aux
isr handler implementation since it is always complete dp_aux_cmd_fifo_tx()
even irq is not for aux read or write transaction. This may cause aux read
transaction return premature if host aux data read is in the middle of
waiting for sink to complete transferring data to host while irq happen.
This will cause host's receiving buffer contains unexpected data. This
patch fixes this problem by checking aux isr and return immediately at
aux isr handler if there are no any isr status bits set.

Current there is a bug report regrading eDP edid corruption happen during
system booting up. After lengthy debugging to found that VIDEO_READY
interrupt was continuously firing during system booting up which cause
dp_aux_isr() to complete dp_aux_cmd_fifo_tx() prematurely to retrieve data
from aux hardware buffer which is not yet contains complete data transfer
from sink. This cause edid corruption.

Follows are the signature at kernel logs when problem happen,
EDID has corrupt header
panel-simple-dp-aux aux-aea0000.edp: Couldn't identify panel via EDID

Changes in v2:
-- do complete if (ret == IRQ_HANDLED) ay dp-aux_isr()
-- add more commit text

Changes in v3:
-- add Stephen suggested
-- dp_aux_isr() return IRQ_XXX back to caller
-- dp_ctrl_isr() return IRQ_XXX back to caller

Changes in v4:
-- split into two patches

Changes in v5:
-- delete empty line between tags

Changes in v6:
-- remove extra "that" and fixed line more than 75 char at commit text

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/516121/
Link: https://lore.kernel.org/r/1672193785-11003-2-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -423,6 +423,10 @@ void dp_aux_isr(struct drm_dp_aux *dp_au
 
 	isr = dp_catalog_aux_get_irq(aux->catalog);
 
+	/* no interrupts pending, return immediately */
+	if (!isr)
+		return;
+
 	if (!aux->cmd_busy)
 		return;
 


