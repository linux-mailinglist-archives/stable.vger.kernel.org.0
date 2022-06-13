Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343F954909E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382035AbiFMOQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382289AbiFMON4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B31A9AE49;
        Mon, 13 Jun 2022 04:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E842B613F9;
        Mon, 13 Jun 2022 11:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01816C34114;
        Mon, 13 Jun 2022 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120535;
        bh=XHXZMpOCvpB+hVo3r4vGG0BGyFr/7psW/iBEtN1fhuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGgJDeIwq8gOD4StGYMUC6NBIMJ85hHoJErDtBhjezYW+DN9E+xAtjOlx3e6aPZbW
         /VbJaYEYvJtoJIpoUnrc3JKX9/ezfgHRnYqH9SvZ6EoOQ+D8MdyUZgEMSMUjbynvAq
         6LV09rjx7Xs6txBr62f0zaiNPFZQNK9Zo2WAjrcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 034/298] rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails
Date:   Mon, 13 Jun 2022 12:08:48 +0200
Message-Id: <20220613094925.966586535@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

[ Upstream commit 59d6f72f6f9c92fec8757d9e29527da828e9281f ]

irq_of_parse_and_map() returns 0 on failure, so this should not be
passed further as error return code.

Fixes: 1a358d350664 ("rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220423093932.32136-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index d4b54eebe15d..4ad90945518f 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1406,7 +1406,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 	irq = irq_of_parse_and_map(node, 0);
 	if (!irq) {
 		dev_err(dev, "required smd interrupt missing\n");
-		ret = irq;
+		ret = -EINVAL;
 		goto put_node;
 	}
 
-- 
2.35.1



