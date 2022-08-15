Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF31593A43
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbiHOTdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbiHOTbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188EA61D40;
        Mon, 15 Aug 2022 11:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C92611C1;
        Mon, 15 Aug 2022 18:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55881C433C1;
        Mon, 15 Aug 2022 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589101;
        bh=9cdqy1RC1yntKX06V8HA9t5CMzYLghHcz50V6NAkJA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR7jqsd81Sa+42LcFjpt1hGrvgiyuxZ6DzFY3coINh2hB8Ud/+JrSWnuhqXlwykSW
         4nDTzuD9OJyf7wd3BRVf3VBleb2moBg7rvVvsVvqwzFJgppTjKIRbWZuQTumGNiZ56
         M0naaVBiklkz4FgvnZ+0/q7O/EmtwsoJJEXC22pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Gupta <sidgup@codeaurora.org>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/779] remoteproc: qcom: pas: Check if coredump is enabled
Date:   Mon, 15 Aug 2022 20:04:17 +0200
Message-Id: <20220815180403.570623098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Siddharth Gupta <sidgup@codeaurora.org>

[ Upstream commit 7b6ece968fca4ec9e42d34caff7e06dc84c45717 ]

Client drivers need to check if coredump is enabled for the rproc before
continuing with coredump generation. This change adds a check in the PAS
driver.

Fixes: 8ed8485c4f05 ("remoteproc: qcom: Add capability to collect minidumps")
Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1657022900-2049-5-git-send-email-quic_sibis@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 699eaac5b760..78d90d856e40 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -87,6 +87,9 @@ static void adsp_minidump(struct rproc *rproc)
 {
 	struct qcom_adsp *adsp = rproc->priv;
 
+	if (rproc->dump_conf == RPROC_COREDUMP_DISABLED)
+		return;
+
 	qcom_minidump(rproc, adsp->minidump_id);
 }
 
-- 
2.35.1



