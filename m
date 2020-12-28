Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D722E4077
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502748AbgL1Ow2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501983AbgL1OSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB25D208B6;
        Mon, 28 Dec 2020 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165078;
        bh=kx/tp4SqoPRPduAGYsbIFkZwQcXb64ozLaWoYI2fSwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgQd24gMQjuxSJRAgHEGsSg3IyMp/qB7kdkJfD6jGY/KGCYToHiGZRLBczLtfxrD3
         nSTSaxWcOTlBdk6Xi5OYIeGeYaJ0modXzHLWtButPgdxI52f7HmOSgMSqqdgglVs0f
         ZTq1MAYY1SlxOeXZ8tQqkD8FZSVCU+wnAEEA6tI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/717] remoteproc: qcom: pas: fix error handling in adsp_pds_enable
Date:   Mon, 28 Dec 2020 13:46:40 +0100
Message-Id: <20201228125040.251411008@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit c0a6e5ee1ecfe4c3a5799cfd30820748eff5dfab ]

If the pm_runtime_get_sync failed in adsp_pds_enable when
loop (i), The unroll_pd_votes will start from (i - 1), and
it will resulted in following problems:

  1) pm_runtime_get_sync will increment pm usage counter even it
     failed. Forgetting to pm_runtime_put_noidle will result in
     reference leak.

  2) Have not reset pds[i] performance state.

Then we fix it.

Fixes: 17ee2fb4e8567 ("remoteproc: qcom: pas: Vote for active/proxy power domains")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102143554.144707-1-zhangqilong3@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 3837f23995e05..0678b417707ef 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -90,8 +90,11 @@ static int adsp_pds_enable(struct qcom_adsp *adsp, struct device **pds,
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



