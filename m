Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BEA59E2B5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357341AbiHWLRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357628AbiHWLQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A40BD15A;
        Tue, 23 Aug 2022 02:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BC460F85;
        Tue, 23 Aug 2022 09:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA81BC433C1;
        Tue, 23 Aug 2022 09:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246363;
        bh=bmnVsemfRatUsVlT5aEAQxEC3doJojh9EFpg1tDrL4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2iMCIRSs/jk2the4N/COOaTD51XDYiEjw9SbwhpEOfWT9Hmobuj+78vLQjcrtDe7
         IJ0hX7CmMGpAfofIqubXwDcSIzSiieWF6nlkAHZUeZRsjbMIdFadY/mNAWYg2ksEBQ
         y+fflcv/zwdnHvq9Ew0bkGIgE1JICKDZRLhyCC74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/389] soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
Date:   Tue, 23 Aug 2022 10:22:43 +0200
Message-Id: <20220823080119.184396555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

[ Upstream commit e6e0951414a314e7db3e9e24fd924b3e15515288 ]

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node.
When breaking early from a for_each_available_child_of_node() loop,
we need to explicitly call of_node_put() on the child node.
Add missing of_node_put() to avoid refcount leak.

Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake up the SoC.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220606064252.42595-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_aoss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index f16d6ec78064..bca98df55bc6 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -489,8 +489,10 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
 			continue;
 		ret = qmp_cooling_device_add(qmp, &qmp->cooling_devs[count++],
 					     child);
-		if (ret)
+		if (ret) {
+			of_node_put(child);
 			goto unroll;
+		}
 	}
 
 	if (!count)
-- 
2.35.1



