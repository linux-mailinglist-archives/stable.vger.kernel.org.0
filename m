Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAA4F27BA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbiDEIIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiDEICR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8D54DF76;
        Tue,  5 Apr 2022 01:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280D5B81B14;
        Tue,  5 Apr 2022 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D5C340EE;
        Tue,  5 Apr 2022 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145617;
        bh=U4zrHvuKONmFfOKqwWcYvoIZQzfADdQU6l6uwhJOr6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuI8LfWmywdl3WeCsnrIPwQzItdfihsxgx3RSEyr1n/Nisd878LuvMxqdDHNWHDLs
         1Nc/GXFLPVDEiOa1UtqOs5CLefeszDYxLKM6afBuOFGjkdj5RV2D/8fu3WccPvrMuy
         yFz1EXDbsPQfSLY+TABz/IccgeSFu66c28DRlAEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0429/1126] ath11k: add missing of_node_put() to avoid leak
Date:   Tue,  5 Apr 2022 09:19:36 +0200
Message-Id: <20220405070420.217140424@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3d38faef0de1756994b3d95e47b2302842f729e2 ]

The node pointer is returned by of_find_node_by_type()
or of_parse_phandle() with refcount incremented. Calling
of_node_put() to aovid the refcount leak.

Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211221114003.335557-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 1 +
 drivers/net/wireless/ath/ath11k/qmi.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index e4250ba8dfee..cccaa348cf21 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -332,6 +332,7 @@ static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
 		return -ENOENT;
 
 	ret = of_address_to_resource(np, 0, &res);
+	of_node_put(np);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 65d3c6ba35ae..42c2ad3e3668 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1936,6 +1936,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 			}
 
 			ret = of_address_to_resource(hremote_node, 0, &res);
+			of_node_put(hremote_node);
 			if (ret) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,
 					   "qmi fail to get reg from hremote\n");
-- 
2.34.1



