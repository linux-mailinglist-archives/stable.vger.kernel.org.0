Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF44F36A6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiDELGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348213AbiDEJrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62106EAC81;
        Tue,  5 Apr 2022 02:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E916B81B75;
        Tue,  5 Apr 2022 09:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFE5C385A0;
        Tue,  5 Apr 2022 09:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151204;
        bh=fzc4q4gZLney9QwrOtP6lm/QNQXxrEaZFH5DeGM5/BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXzEgS0AxQblUxGgInoJH0m+4mBx+5TlJOJa1Tj9R05gPg4M68Q2fn9J26/MWTyIm
         ZsvUQ/eAlB+AvNZy2tnw/iVC5qylIz+mba6MrKCe6mvJ1dj3ntEYg8c8zpgW/Ca//i
         WkVMmJhVC/SeGlCMesXx8cRyCp0QOSz07a7j1DyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/913] firmware: qcom: scm: Remove reassignment to desc following initializer
Date:   Tue,  5 Apr 2022 09:22:36 +0200
Message-Id: <20220405070348.669236024@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 7823e5aa5d1dd9ed5849923c165eb8f29ad23c54 ]

Member assignments to qcom_scm_desc were moved into struct initializers
in 57d3b816718c ("firmware: qcom_scm: Remove thin wrappers") including
the case in qcom_scm_iommu_secure_ptbl_init, except that the - now
duplicate - assignment to desc was left in place. While not harmful,
remove this unnecessary extra reassignment.

Fixes: 57d3b816718c ("firmware: qcom_scm: Remove thin wrappers")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211208083423.22037-2-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 27a64de91981..2b5214d5c0da 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -749,12 +749,6 @@ int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
 	};
 	int ret;
 
-	desc.args[0] = addr;
-	desc.args[1] = size;
-	desc.args[2] = spare;
-	desc.arginfo = QCOM_SCM_ARGS(3, QCOM_SCM_RW, QCOM_SCM_VAL,
-				     QCOM_SCM_VAL);
-
 	ret = qcom_scm_call(__scm->dev, &desc, NULL);
 
 	/* the pg table has been initialized already, ignore the error */
-- 
2.34.1



