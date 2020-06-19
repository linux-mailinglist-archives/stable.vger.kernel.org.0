Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29126201323
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405383AbgFSP53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388925AbgFSPUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A452206DB;
        Fri, 19 Jun 2020 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580010;
        bh=qMBN6ywlGZR40UxUS7UN9pzv36EbDklsZp2ZsKOoD8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pf3YGu/760m0OOGABnQ6FxTQP3TdD1UO48fT4XshoHOI34Yd/dTCK46OGFtxWSJqy
         trRIfyKfw34Q3n77FZYH8Q30qkZjXrc6Bv2N1V/f34qnA3B/VX8xtjTHERk8ZCPbNk
         BgeXajphTCwgKGkdyfIZH1G6DqSwNfjE0Dl0afKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 089/376] media: venus: core: remove CNOC voting while device suspend
Date:   Fri, 19 Jun 2020 16:30:07 +0200
Message-Id: <20200619141714.556804588@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 07f8f22a33a9e3e9955e24a84e2f856dcc8c31c4 ]

The Venus driver is voting Configuration NoC during .probe but not clear
voting in .suspend. Because of this NoC is up during shutdown also. As a
consequence the whole device could leak energy while in .suspend.

So correct this by moving voting in .resume and unvoting
in .suspend

Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 194b10b98767..13fa5076314c 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -242,10 +242,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
-	if (ret)
-		return ret;
-
 	ret = hfi_create(core, &venus_core_ops);
 	if (ret)
 		return ret;
@@ -350,6 +346,10 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	ret = icc_set_bw(core->cpucfg_path, 0, 0);
+	if (ret)
+		return ret;
+
 	if (pm_ops->core_power)
 		ret = pm_ops->core_power(dev, POWER_OFF);
 
@@ -368,6 +368,10 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 			return ret;
 	}
 
+	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
+	if (ret)
+		return ret;
+
 	return hfi_core_resume(core, false);
 }
 
-- 
2.25.1



