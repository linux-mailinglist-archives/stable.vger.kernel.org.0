Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E429A328DF7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbhCATVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241181AbhCATPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0C4464F68;
        Mon,  1 Mar 2021 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618354;
        bh=paZs/kfVvmPSMjQHABpCoQawtPwaTll39jcDG95uWQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxArnueJGbzblYJXoj+NPZrrHIbbnzgFLFqtLugpCArygmvUHvROpEzZX2dbGZ2iv
         S3NGF1t2HnKxjSzbfdP6mFXeiYVN68gE+khcvf6l+afpbn5dlkCe6AKMZh2LxWkEHL
         5KUKppTCDSf4iskrHQHz+E5JLQCW/cyBGfdwbjsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/663] soc: qcom: socinfo: Fix an off by one in qcom_show_pmic_model()
Date:   Mon,  1 Mar 2021 17:05:04 +0100
Message-Id: <20210301161144.528704289@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5fb33d8960dc7abdabc6fe599a30c2c99b082ef6 ]

These need to be < ARRAY_SIZE() instead of <= ARRAY_SIZE() to prevent
accessing one element beyond the end of the array.

Acked-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Fixes: e9247e2ce577 ("soc: qcom: socinfo: fix printing of pmic_model")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YAf+o85Z9lgkq3Nw@mwanda
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index b44ede48decc0..e0620416e5743 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -280,7 +280,7 @@ static int qcom_show_pmic_model(struct seq_file *seq, void *p)
 	if (model < 0)
 		return -EINVAL;
 
-	if (model <= ARRAY_SIZE(pmic_models) && pmic_models[model])
+	if (model < ARRAY_SIZE(pmic_models) && pmic_models[model])
 		seq_printf(seq, "%s\n", pmic_models[model]);
 	else
 		seq_printf(seq, "unknown (%d)\n", model);
-- 
2.27.0



