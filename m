Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E04F267D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiDEIFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiDEIAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6EB4838D;
        Tue,  5 Apr 2022 00:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 933EBB81B14;
        Tue,  5 Apr 2022 07:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E515AC340EE;
        Tue,  5 Apr 2022 07:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145526;
        bh=zH4l9z6y8J1WX/sN6BszQgli3CXzxmepCxSY80aVahM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwlQ2XVG+HzSgpDeqvWcLd7moOYmBt8Fj3x4x1qq4JUcfvUeLWKlSO4TEjFwK4qZT
         oMNMKvehXDE5h19SRUnXfNMiLxXWmlwmI/nRj5SkJLApx8ZLMqR5gxF6UUVV8QKb/M
         NxARHcftEoIKC6VAnj3OanNU6sh01WdQLFO+QVqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0438/1126] ath11k: fix error code in ath11k_qmi_assign_target_mem_chunk()
Date:   Tue,  5 Apr 2022 09:19:45 +0200
Message-Id: <20220405070420.480630328@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c9b41832dc080fa59bad597de94865b3ea2d5bab ]

The "ret" vairable is not set at this point.  It could be uninitialized
or zero.  The correct thing to return is -ENODEV.

Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220111071445.GA11243@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 42c2ad3e3668..d0701e8eca9c 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1932,7 +1932,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 			if (!hremote_node) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,
 					   "qmi fail to get hremote_node\n");
-				return ret;
+				return -ENODEV;
 			}
 
 			ret = of_address_to_resource(hremote_node, 0, &res);
-- 
2.34.1



