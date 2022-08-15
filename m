Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8F9594494
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345184AbiHOWkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351364AbiHOWiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20D013263E;
        Mon, 15 Aug 2022 12:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DBFD6122B;
        Mon, 15 Aug 2022 19:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468DCC433D6;
        Mon, 15 Aug 2022 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593065;
        bh=Da0gbbdZzQ1GHA0R171QoB/svWQr1XAmx/vQ/xxRN9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABT+zv6HQKN2PWzFlc4pmNYzZ//+UPTM8SA4sHgXPis7LyPQNPuhNW5EBNTF2tWiv
         CEGEzb2vejhF8OHiAmF24xVGVB65OMCVK3WMMnwQrIa+8V9X79ip/i4asAZ+u4bFiv
         nu/X9ypaf/Mz95eW5ggw+WykCa4rABDhCADMke2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0887/1095] rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge
Date:   Mon, 15 Aug 2022 20:04:46 +0200
Message-Id: <20220815180506.030325207@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 65382585f067d4256ba087934f30f85c9b6984de ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.

Fixes: 53e2822e56c7 ("rpmsg: Introduce Qualcomm SMD backend")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220511120737.57374-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 1957b27c4cf3..f7af53891ef9 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1383,6 +1383,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 		}
 
 		edge->ipc_regmap = syscon_node_to_regmap(syscon_np);
+		of_node_put(syscon_np);
 		if (IS_ERR(edge->ipc_regmap)) {
 			ret = PTR_ERR(edge->ipc_regmap);
 			goto put_node;
-- 
2.35.1



