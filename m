Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA64F36A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiDELGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348240AbiDEJrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2018AEACA2;
        Tue,  5 Apr 2022 02:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAFCB81C85;
        Tue,  5 Apr 2022 09:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E08C385A2;
        Tue,  5 Apr 2022 09:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151210;
        bh=u1M5fWZoiYvm3eL5IGiUHURHVQOxWM5G0v5FSAtPShY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJgwJOkyRmZXyyEq1DB3PjbeiSpyq2Zjzfvr32dkzbeJmwRH35UK6Saj7lwp/2i2w
         LzvEE+dNgAvOq19BrIOebU7IFjKAcPpzGFSD9QndpH+efIsbteQhSLx68cjQCJhtm6
         Y+HXL3wCvyXrb/quha6EtMpDAVo+Y9F9Q4F2Tc80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/913] soc: qcom: rpmpd: Check for null return of devm_kcalloc
Date:   Tue,  5 Apr 2022 09:22:38 +0200
Message-Id: <20220405070348.729943511@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 5a811126d38f9767a20cc271b34db7c8efc5a46c ]

Because of the possible failure of the allocation, data->domains might
be NULL pointer and will cause the dereference of the NULL pointer
later.
Therefore, it might be better to check it and directly return -ENOMEM
without releasing data manually if fails, because the comment of the
devm_kmalloc() says "Memory allocated with this function is
automatically freed on driver detach.".

Fixes: bbe3a66c3f5a ("soc: qcom: rpmpd: Add a Power domain driver to model corners")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211231094419.1941054-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmpd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/qcom/rpmpd.c b/drivers/soc/qcom/rpmpd.c
index dbf494e92574..9f07274b0d28 100644
--- a/drivers/soc/qcom/rpmpd.c
+++ b/drivers/soc/qcom/rpmpd.c
@@ -546,6 +546,9 @@ static int rpmpd_probe(struct platform_device *pdev)
 
 	data->domains = devm_kcalloc(&pdev->dev, num, sizeof(*data->domains),
 				     GFP_KERNEL);
+	if (!data->domains)
+		return -ENOMEM;
+
 	data->num_domains = num;
 
 	for (i = 0; i < num; i++) {
-- 
2.34.1



