Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8ED4F463F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380549AbiDEMNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357960AbiDEK1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96237B6E46;
        Tue,  5 Apr 2022 03:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E898617A4;
        Tue,  5 Apr 2022 10:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175FBC385A1;
        Tue,  5 Apr 2022 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153501;
        bh=yHW2nIW4xOOOvIV8sPoV3gr9Hs17N6DHwCarP2t75uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEadMo94nGMGpqG+DYy+QVlx7ySCHdst3mEXQt+/v7TCssFnVcteE6DbJasSqYSWi
         2JPzfTxcprbJm20AQ21AxmX4eabnlh3FH/GTy+nxM48OVkRko8rUDjNL290vRSwvJ5
         qLawB3shkwIJunRfnu9VoACaC8kt2chKtC6GnhgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/599] soc: qcom: rpmpd: Check for null return of devm_kcalloc
Date:   Tue,  5 Apr 2022 09:28:19 +0200
Message-Id: <20220405070304.942382196@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index f2168e4259b2..c6084c0d3530 100644
--- a/drivers/soc/qcom/rpmpd.c
+++ b/drivers/soc/qcom/rpmpd.c
@@ -387,6 +387,9 @@ static int rpmpd_probe(struct platform_device *pdev)
 
 	data->domains = devm_kcalloc(&pdev->dev, num, sizeof(*data->domains),
 				     GFP_KERNEL);
+	if (!data->domains)
+		return -ENOMEM;
+
 	data->num_domains = num;
 
 	for (i = 0; i < num; i++) {
-- 
2.34.1



