Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586E65015AF
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbiDNNeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245235AbiDNN2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D90ABF53;
        Thu, 14 Apr 2022 06:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73F16B82983;
        Thu, 14 Apr 2022 13:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D43C385A9;
        Thu, 14 Apr 2022 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942522;
        bh=7tC9N9K7h7F5wqSG4QEWvvv++nUv46El3mP7cV2LxAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSozJ7qrTedu/61frFGFZbyfDSLpJcUkzUy246AbamhzCuMz5brm6CPf0Inx9WZDm
         e+MzW98mgq0MSZqZuxu2ehP1DmX4TC5wQA5ksRzhtbgaKYGt8V1fm9oQ3hB3OzdRpb
         WrV9Ismfvkf6XJtcIjywOSY9hE37SWecAqALI6n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/338] remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
Date:   Thu, 14 Apr 2022 15:11:10 +0200
Message-Id: <20220414110843.653637440@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

[ Upstream commit 8f90161a66bc3d6b9fe8dde4d9028d20eae1b62a ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: aed361adca9f ("remoteproc: qcom: Introduce WCNSS peripheral image loader")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220308063102.10049-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index b0e07e9f42d5..6cc0f9a5533e 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -448,6 +448,7 @@ static int wcnss_alloc_memory_region(struct qcom_wcnss *wcnss)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
-- 
2.34.1



