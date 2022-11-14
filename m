Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A965627FA7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiKNNBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbiKNNBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0128E2E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37AF61185
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D568CC433D6;
        Mon, 14 Nov 2022 13:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430866;
        bh=a+B5EDo+CWbn4dxVurRfH1vkEuN1bk5TEUBPx81hUOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1xHR4udv1EwlSwWhIou7VKzl6bT5UTRULfFWnaxREWxrEZSPBcRS/29nKVw54GME
         9vrDAuakfyd8oiasP8x45QrJAuQDiq23Oa9kIDUBnhAqNlRadM/FZClh9FAJBLWkaF
         Ze6urcZwVLaKK16CqHqZIqBn87cdFC+4h83Capz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 019/190] soundwire: qcom: reinit broadcast completion
Date:   Mon, 14 Nov 2022 13:44:03 +0100
Message-Id: <20221114124459.615118398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit f936fa7a954b262cb3908bbc8f01ba19dfaf9fbf ]

For some reason we never reinit the broadcast completion, there is a
danger that broadcast commands could be treated as completed by driver
from previous complete status.
Fix this by reinitializing the completion before sending a broadcast command.

Fixes: ddea6cf7b619 ("soundwire: qcom: update register read/write routine")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221026110210.6575-2-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 3a992a6478c3..87ccaebc8453 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -344,6 +344,9 @@ static int qcom_swrm_cmd_fifo_wr_cmd(struct qcom_swrm_ctrl *swrm, u8 cmd_data,
 	if (swrm_wait_for_wr_fifo_avail(swrm))
 		return SDW_CMD_FAIL_OTHER;
 
+	if (cmd_id == SWR_BROADCAST_CMD_ID)
+		reinit_completion(&swrm->broadcast);
+
 	/* Its assumed that write is okay as we do not get any status back */
 	swrm->reg_write(swrm, SWRM_CMD_FIFO_WR_CMD, val);
 
-- 
2.35.1



