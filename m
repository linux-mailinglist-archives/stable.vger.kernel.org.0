Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F60593E28
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbiHOUhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345000AbiHOUfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AF52AE39;
        Mon, 15 Aug 2022 12:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0865261281;
        Mon, 15 Aug 2022 19:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A715C433D6;
        Mon, 15 Aug 2022 19:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590390;
        bh=T8AMqL1bI2nByzhLxcyPhAwx+e3draOCLCZ86QLTzuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n78bBB+13YmSCJc/oii4UF4Fi9lwYLpsG4q8ro2RdLZjwuSsuQpm8efkpK7nj7BdX
         NF41+A11qlTjxT8MXOH01200lIaJgSsvV+idfkn70t4hKOnk/OeSzb9lKvhL6b4G27
         ftRH2g3nqf+a4BwTO3XgxF0KWan0u1HqX8ajrbHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0245/1095] soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
Date:   Mon, 15 Aug 2022 19:54:04 +0200
Message-Id: <20220815180439.925219341@linuxfoundation.org>
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
index a59bb34e5eba..18c856056475 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -399,8 +399,10 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
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



