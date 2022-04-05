Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD534F26CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiDEIEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiDEH7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A262F56748;
        Tue,  5 Apr 2022 00:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FDC9B81B14;
        Tue,  5 Apr 2022 07:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F68CC340EE;
        Tue,  5 Apr 2022 07:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145227;
        bh=yOOcSr49yintFws5LQ3lcCr1SVHOjBqKbUYhL8Nkog8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHRmDHEN7a2ysBDtR/0AeThhyAJw+gIGhoR48FoZTr8qWd4a3fIlgRP8bbhj+QcwA
         6CtJFbekRYTihLweDcHipBt7Ujxm/3LOwc9l10cz88fLCN3TR04ZOvboJNDMg046hJ
         QIB3h/dcy83uzDrxg1zZ2w/M1bRMJUQNxp236VDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0330/1126] soc: qcom: aoss: remove spurious IRQF_ONESHOT flags
Date:   Tue,  5 Apr 2022 09:17:57 +0200
Message-Id: <20220405070417.304409478@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit 8030cb9a55688c1339edd284d9d6ce5f9fc75160 ]

Quoting the header comments, IRQF_ONESHOT is "Used by threaded interrupts
which need to keep the irq line disabled until the threaded handler has
been run.". When applied to an interrupt that doesn't request a threaded
irq then IRQF_ONESHOT has a lesser known (undocumented?) side effect,
which it to disable the forced threading of the irq. For "normal" kernels
(without forced threading) then, if there is no thread_fn, then
IRQF_ONESHOT is a nop.

In this case disabling forced threading is not appropriate for this driver
because it calls wake_up_all() and this API cannot be called from
no-thread interrupt handlers on PREEMPT_RT systems (deadlock risk, triggers
sleeping-while-atomic warnings).

Fix this by removing IRQF_ONESHOT.

Fixes: 2209481409b7 ("soc: qcom: Add AOSS QMP driver")
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
[bjorn: Added Fixes tag]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220127173554.158111-1-daniel.thompson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_aoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index 563ae0a501dc..a59bb34e5eba 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -501,7 +501,7 @@ static int qmp_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	ret = devm_request_irq(&pdev->dev, irq, qmp_intr, IRQF_ONESHOT,
+	ret = devm_request_irq(&pdev->dev, irq, qmp_intr, 0,
 			       "aoss-qmp", qmp);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request interrupt\n");
-- 
2.34.1



