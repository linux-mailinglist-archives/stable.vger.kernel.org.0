Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E267137C87E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhELQJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236457AbhELQEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:04:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 854CD61975;
        Wed, 12 May 2021 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833652;
        bh=SFsEdzgUCHwvpU+fpW+I16Oy+MkLtZXnhsQTC7kfIpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2O1QyG5APRcJ9cE9f+wnY0X8DfK/w28ydt45PZ2UX1t8v3HH8KaOHI5+MK8IkrU+
         Hr1P8N+q9jznXg5q0B+y6Fl6EPrcM6ucVsXfMsekVbivurGiz764GlNQxmDkKVfxEt
         wJ9BPVMYpTmOKci7QcY9eNQ02Ml5Y4dUCYoy++NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliot Berman <eberman@codeaurora.org>,
        Brian Masney <masneyb@onstation.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 235/601] firmware: qcom_scm: Workaround lack of "is available" call on SC7180
Date:   Wed, 12 May 2021 16:45:12 +0200
Message-Id: <20210512144835.563016147@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 257f2935cbbf14b16912c635fcd8ff43345c953b ]

Some SC7180 firmwares don't implement the QCOM_SCM_INFO_IS_CALL_AVAIL
API, so we can't probe the calling convention. We detect the legacy
calling convention on these firmwares, because the availability call
always fails and legacy is the fallback. This leads to problems where
the rmtfs driver fails to probe, because it tries to assign memory with
a bad calling convention, which then leads to modem failing to load and
all networking, even wifi, to fail. Ouch!

Let's force the calling convention to be what it always is on this SoC,
i.e. arm64. Of course, the calling convention is not the same thing as
implementing the QCOM_SCM_INFO_IS_CALL_AVAIL API. The absence of the "is
this call available" API from the firmware means that any call to
__qcom_scm_is_call_available() fails. This is OK for now though because
none of the calls that are checked for existence are implemented on
firmware running on sc7180. If such a call needs to be checked for
existence in the future, we presume that firmware will implement this
API and then things will "just work".

Cc: Elliot Berman <eberman@codeaurora.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 9a434cee773a ("firmware: qcom_scm: Dynamically support SMCCC and legacy conventions")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210223214539.1336155-4-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index a455c22bcdbd..c5b20bdc08e9 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -131,6 +131,7 @@ static enum qcom_scm_convention __get_convention(void)
 	struct qcom_scm_res res;
 	enum qcom_scm_convention probed_convention;
 	int ret;
+	bool forced = false;
 
 	if (likely(qcom_scm_convention != SMC_CONVENTION_UNKNOWN))
 		return qcom_scm_convention;
@@ -144,6 +145,18 @@ static enum qcom_scm_convention __get_convention(void)
 	if (!ret && res.result[0] == 1)
 		goto found;
 
+	/*
+	 * Some SC7180 firmwares didn't implement the
+	 * QCOM_SCM_INFO_IS_CALL_AVAIL call, so we fallback to forcing ARM_64
+	 * calling conventions on these firmwares. Luckily we don't make any
+	 * early calls into the firmware on these SoCs so the device pointer
+	 * will be valid here to check if the compatible matches.
+	 */
+	if (of_device_is_compatible(__scm ? __scm->dev->of_node : NULL, "qcom,scm-sc7180")) {
+		forced = true;
+		goto found;
+	}
+
 	probed_convention = SMC_CONVENTION_ARM_32;
 	ret = __scm_smc_call(NULL, &desc, probed_convention, &res, true);
 	if (!ret && res.result[0] == 1)
@@ -154,8 +167,9 @@ found:
 	spin_lock_irqsave(&scm_query_lock, flags);
 	if (probed_convention != qcom_scm_convention) {
 		qcom_scm_convention = probed_convention;
-		pr_info("qcom_scm: convention: %s\n",
-			qcom_scm_convention_names[qcom_scm_convention]);
+		pr_info("qcom_scm: convention: %s%s\n",
+			qcom_scm_convention_names[qcom_scm_convention],
+			forced ? " (forced)" : "");
 	}
 	spin_unlock_irqrestore(&scm_query_lock, flags);
 
-- 
2.30.2



