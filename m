Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED8627FAA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbiKNNBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbiKNNBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA2029344
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53695B80EC3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58613C433D6;
        Mon, 14 Nov 2022 13:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430870;
        bh=jT3OgjaSeEqJc6+Eei2sAEsM3mQUyEEbC151IlMonNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRGNZfQ6YCjSOBamBkTKR+zyN6o8EPleneaqyWUwlS9HqFPBD8aaUnQrxPnnhIBfY
         R2M+VgCXCsUHbRqj3CE8Opr6BEhkSYSVEzA9ggPr/aNkyF4vHon3tiCnCDsiVhvT8C
         InxDCsVcvjstxBAkAAF3Fz8enKd8Gnng5nf3tEyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 020/190] soundwire: qcom: check for outanding writes before doing a read
Date:   Mon, 14 Nov 2022 13:44:04 +0100
Message-Id: <20221114124459.665032924@linuxfoundation.org>
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

[ Upstream commit 49a467310dc4fae591a3547860ee04d8730780f4 ]

Reading will increase the fifo count, so check for outstanding cmd wrt.
write fifo depth to avoid overflow as read will also increase
write fifo cnt.

Fixes: a661308c34de ("soundwire: qcom: wait for fifo space to be available before read/write")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221026110210.6575-3-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 87ccaebc8453..6e5990611d83 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -380,6 +380,12 @@ static int qcom_swrm_cmd_fifo_rd_cmd(struct qcom_swrm_ctrl *swrm,
 
 	val = swrm_get_packed_reg_val(&swrm->rcmd_id, len, dev_addr, reg_addr);
 
+	/*
+	 * Check for outstanding cmd wrt. write fifo depth to avoid
+	 * overflow as read will also increase write fifo cnt.
+	 */
+	swrm_wait_for_wr_fifo_avail(swrm);
+
 	/* wait for FIFO RD to complete to avoid overflow */
 	usleep_range(100, 105);
 	swrm->reg_write(swrm, SWRM_CMD_FIFO_RD_CMD, val);
-- 
2.35.1



