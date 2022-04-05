Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655174F2A26
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiDEJwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243720AbiDEJJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C853C9B4E;
        Tue,  5 Apr 2022 01:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54B16615E3;
        Tue,  5 Apr 2022 08:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1B5C385A8;
        Tue,  5 Apr 2022 08:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149108;
        bh=u8PxMLCYo4rYp2EXONipyGluuU3I5q0QkRQTH2Ha+LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2jBlvnkG/OBhNQz3/mJXYIhDymcMlvhzRkGyL8Y4arWmSvkId2hZ4Nn03XJFcyOY
         tJiRZVoxu2QFMSkkf/20spx4AlfLH695XVls6a+MpbFCYie1E+2z5XvoEaHmJM0HJv
         YjFsoHw+bMU09yd2TqG54MegxGFktjM7iCTKOfDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0590/1017] ath10k: Fix error handling in ath10k_setup_msa_resources
Date:   Tue,  5 Apr 2022 09:25:03 +0200
Message-Id: <20220405070411.792477692@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9747a78d5f758a5284751a10aee13c30d02bd5f1 ]

The device_node pointer is returned by of_parse_phandle() with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error path.

Fixes: 727fec790ead ("ath10k: Setup the msa resources before qmi init")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220308070238.19295-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9513ab696fff..f79dd9a71690 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1556,11 +1556,11 @@ static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
 	node = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (node) {
 		ret = of_address_to_resource(node, 0, &r);
+		of_node_put(node);
 		if (ret) {
 			dev_err(dev, "failed to resolve msa fixed region\n");
 			return ret;
 		}
-		of_node_put(node);
 
 		ar->msa.paddr = r.start;
 		ar->msa.mem_size = resource_size(&r);
-- 
2.34.1



