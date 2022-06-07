Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B821540670
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347381AbiFGRfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346985AbiFGRcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9355F8EA;
        Tue,  7 Jun 2022 10:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B8460BC6;
        Tue,  7 Jun 2022 17:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47918C385A5;
        Tue,  7 Jun 2022 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623002;
        bh=rGUx6AQ9D3IfO4LzuIEfqjxSjzgaw5MqOB16sR62HaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYmTrWeRQtnTsJV1QVxwSk/AoR4316rOzqZ6FFwI4kDKKo7Nlc1LLhPEo4jJ4KxZw
         G5i2jLBxzh/4jGx2+UfjKvT3MBD6Q4b5pNMJN3uldStWo/1bW/GhPLEHeiG9kpjewU
         WeFJr5k/v9qqeiHIFCdFk+QnxRVbgXVmKlqACaoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/452] soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc
Date:   Tue,  7 Jun 2022 19:01:58 +0200
Message-Id: <20220607164916.331179809@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8fd3f18ea31a398ecce4a6d3804433658678b0a3 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 50e99641413e ("soc: qcom: smp2p: Qualcomm Shared Memory Point to Point")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220308071942.22942-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smp2p.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/smp2p.c b/drivers/soc/qcom/smp2p.c
index a9709aae54ab..fb76c8bc3c64 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -420,6 +420,7 @@ static int smp2p_parse_ipc(struct qcom_smp2p *smp2p)
 	}
 
 	smp2p->ipc_regmap = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(smp2p->ipc_regmap))
 		return PTR_ERR(smp2p->ipc_regmap);
 
-- 
2.35.1



