Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6881B2E62C2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406234AbgL1Ntz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406228AbgL1Nty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECBD206D4;
        Mon, 28 Dec 2020 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163373;
        bh=a/C7CUnfF6EEVyg8ji+Ascg7XvcMX91RRzmPssUk0S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aq4pLLlwpReZNjIPFr6Pho0xxu45bdRr1TGDVhknH9m4qXQhUdmrxOGgk+7J0dKWF
         IrZ1P3GF7Lfj7ZvQTkjqggKxIeBI3Xy7n7VGCKz/PEKuG05H1F9WijWy5WpI9HpkjH
         0XHPsF0Dkigr2L/XOhCL7gRVXzNziEKYDjxdKC80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 263/453] remoteproc: q6v5-mss: fix error handling in q6v5_pds_enable
Date:   Mon, 28 Dec 2020 13:48:19 +0100
Message-Id: <20201228124949.879848158@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit a24723050037303e4008b37f1f8dcc99c58901aa ]

If the pm_runtime_get_sync failed in q6v5_pds_enable when
loop (i), The unroll_pd_votes will start from (i - 1), and
it will resulted in following problems:

  1) pm_runtime_get_sync will increment pm usage counter even it
     failed. Forgetting to pm_runtime_put_noidle will result in
     reference leak.

  2) Have not reset pds[i] performance state.

Then we fix it.

Fixes: 4760a896be88e ("remoteproc: q6v5-mss: Vote for rpmh power domains")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102143433.143996-1-zhangqilong3@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index a67c55785b4de..5e54e6f5edb1a 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -331,8 +331,11 @@ static int q6v5_pds_enable(struct q6v5 *qproc, struct device **pds,
 	for (i = 0; i < pd_count; i++) {
 		dev_pm_genpd_set_performance_state(pds[i], INT_MAX);
 		ret = pm_runtime_get_sync(pds[i]);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_noidle(pds[i]);
+			dev_pm_genpd_set_performance_state(pds[i], 0);
 			goto unroll_pd_votes;
+		}
 	}
 
 	return 0;
-- 
2.27.0



