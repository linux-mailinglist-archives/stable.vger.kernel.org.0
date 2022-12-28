Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D2865840A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiL1QyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiL1QxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD0E1CFEA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 014FEB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6BAC433F0;
        Wed, 28 Dec 2022 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246120;
        bh=ZOe+bKsqQUZL1HRBM3mff0Yg2ydfyAUrZqNFuRXj4wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbIBVBgNkVhBPIt/pRyGLsERwflUc8BzaCaZyykipqgvIoIZVvcOPL+s4NhmxsjJ6
         HRZZY0MM2YrMyJc2K4qfNMCuGyenWnaejK0jX8b5mP7OzaugvfACS313HoDcixYrYj
         5DoKKmqJyQkVo7tReT9x9OysQlXBfeCwj89bMH0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rahul Bhattacharjee <quic_rbhattac@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0984/1146] wifi: ath11k: Fix qmi_msg_handler data structure initialization
Date:   Wed, 28 Dec 2022 15:42:03 +0100
Message-Id: <20221228144357.092357126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>

[ Upstream commit ed3725e15a154ebebf44e0c34806c57525483f92 ]

qmi_msg_handler is required to be null terminated by QMI module.
There might be a case where a handler for a msg id is not present in the
handlers array which can lead to infinite loop while searching the handler
and therefore out of bound access in qmi_invoke_handler().
Hence update the initialization in qmi_msg_handler data structure.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Signed-off-by: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221021090126.28626-1-quic_rbhattac@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 51de2208b789..8358fe08c234 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3087,6 +3087,9 @@ static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
 			sizeof(struct qmi_wlfw_fw_init_done_ind_msg_v01),
 		.fn = ath11k_qmi_msg_fw_init_done_cb,
 	},
+
+	/* end of list */
+	{},
 };
 
 static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
-- 
2.35.1



