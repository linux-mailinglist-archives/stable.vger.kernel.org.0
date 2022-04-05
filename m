Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2F64F2E09
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347819AbiDEJ23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244931AbiDEIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9EB24976;
        Tue,  5 Apr 2022 01:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E329661504;
        Tue,  5 Apr 2022 08:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2871C385A0;
        Tue,  5 Apr 2022 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148416;
        bh=+B1K6yVJZhmk/O3MTEvRv6W2ZTCovqloX1k7D8NE4iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8E2cWENb3fds7eVYeAfKjQYF37FNTDUwsDIHwNA0YZh20pMXE65Av/b81u5WTCPZ
         PvW6/Uufch5RznOTRt9KZCcgccFVzHkm+NASSLUUhcMWQ65M2A1QtjWOWpHfs9fk36
         Qfq+FhTePk9G3ZnxR9j0ZaNGwvNEJWNU/o0JU2Zk=
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
Subject: [PATCH 5.16 0310/1017] firmware: qcom: scm: Remove reassignment to desc following initializer
Date:   Tue,  5 Apr 2022 09:20:23 +0200
Message-Id: <20220405070403.478014847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 7db8066b19fd..3f67bf774821 100644
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



