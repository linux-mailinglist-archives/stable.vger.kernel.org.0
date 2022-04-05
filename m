Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7874F362B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244689AbiDEK7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346780AbiDEJp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258BCF2;
        Tue,  5 Apr 2022 02:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8161B81CC1;
        Tue,  5 Apr 2022 09:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DECBC385A3;
        Tue,  5 Apr 2022 09:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151106;
        bh=+tmigAPgxOUXyG8vpQNW9jGjOLFsVPcicykoJQBLNEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZfS9IMco6+3jEsTvD6y9XJbWfRE728c7gRJulZ7NN4nzTf5UukqR2roVBzQRaF01
         hbJ9w5+X7OmK+zT1lDnKoTpL9JMhL/uuMWMkG1AyE3muTVRjdkOoIRsLnuNUrRCEjo
         76DPmsRY6XWNKnP+A7uG5rULN2Xyv6z9pVT92oiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/913] soc: qcom: ocmem: Fix missing put_device() call in of_get_ocmem
Date:   Tue,  5 Apr 2022 09:22:39 +0200
Message-Id: <20220405070348.759773335@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0ff027027e05a866491bbb53494f0e2a61354c85 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: 01f937ffc468 ("soc: qcom: ocmem: don't return NULL in of_get_ocmem")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220107073126.2335-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index f1875dc31ae2..85f82e195ef8 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -206,6 +206,7 @@ struct ocmem *of_get_ocmem(struct device *dev)
 	ocmem = platform_get_drvdata(pdev);
 	if (!ocmem) {
 		dev_err(dev, "Cannot get ocmem\n");
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENODEV);
 	}
 	return ocmem;
-- 
2.34.1



