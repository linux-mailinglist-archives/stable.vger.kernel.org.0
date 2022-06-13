Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E6254901D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377414AbiFMNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378038AbiFMNas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F1B6EC54;
        Mon, 13 Jun 2022 04:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2BDFB80D31;
        Mon, 13 Jun 2022 11:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12966C3411E;
        Mon, 13 Jun 2022 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119523;
        bh=72tc4bIMi/WzF0JQ9Pd7txZATTkGwv0vXHYtqVJ7lA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSi6TUSDh8YzIMAvGZYWTEjREUPzNdpocj/YcXvdyobejcbCfT/upbH7MJ4At+cw2
         M0dbiX3y4X0uU5HE2fcehCHlLPOArJH+aLFgjsHx/LUzBswlaQH7DMLTn2xcp8ECq9
         HB+2mRGYTH4kICLOwQ4iN4JwUK7TvgMO0BTzc6ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 024/339] rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value
Date:   Mon, 13 Jun 2022 12:07:29 +0200
Message-Id: <20220613094927.242788800@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1a358d35066487d228a68303d808bc4721c6b1b9 ]

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Fixes: 53e2822e56c7 ("rpmsg: Introduce Qualcomm SMD backend")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220422105326.78713-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 764c980507be..6ccfa12abd10 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1407,7 +1407,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 		edge->name = node->name;
 
 	irq = irq_of_parse_and_map(node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(dev, "required smd interrupt missing\n");
 		ret = irq;
 		goto put_node;
-- 
2.35.1



