Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4928548D64
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377560AbiFMNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377822AbiFMNaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E116D966;
        Mon, 13 Jun 2022 04:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3F860B6E;
        Mon, 13 Jun 2022 11:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8453AC3411F;
        Mon, 13 Jun 2022 11:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119506;
        bh=Xif9hvYlf02tsdey62zzIn1m8uFjEkOGkwTMmL8npt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/loGXAmDEl7XRe18/4ZiXKzrPdUdmgnXkZAdVxLY7ZyigNLJ8RtmB92XlkULzWrv
         1o8RRbfPHwvtwU8xm/2GMh8pM61N/WnUoLXwUsEKAkpXk7d1/f0c/FcF2I6vXWGa5n
         GkONnReUPx0em99jNEcip35+xxc9YQ9p6ewp4NPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 038/339] rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails
Date:   Mon, 13 Jun 2022 12:07:43 +0200
Message-Id: <20220613094927.674529251@linuxfoundation.org>
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
index 6ccfa12abd10..1957b27c4cf3 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1409,7 +1409,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 	irq = irq_of_parse_and_map(node, 0);
 	if (!irq) {
 		dev_err(dev, "required smd interrupt missing\n");
-		ret = irq;
+		ret = -EINVAL;
 		goto put_node;
 	}
 
-- 
2.35.1



