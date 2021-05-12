Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE9F37C446
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhELP34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234872AbhELPZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6097F61482;
        Wed, 12 May 2021 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832251;
        bh=JwloACa9axXIauNZtkciFVzPby9Jpw543exXJriXTzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whIdEaYwkkS2OpWqv40ueN3H8OnRE+Pt2LNIyFgQBVpo7EXpGh55oxxoamHCRZz5P
         KzZ3EzCkUtnLK/OS6QVQYjkBXzfKAL7OH+HuwNtufY/SIIxqQKqiJ3/l5NQ7SnlDq8
         2OWoKnYa5913ylRnwyX2Gwo8cBpnn0HzNWi93F5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Brian Masney <masneyb@onstation.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/530] firmware: qcom_scm: Make __qcom_scm_is_call_available() return bool
Date:   Wed, 12 May 2021 16:45:13 +0200
Message-Id: <20210512144826.514077862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 9d11af8b06a811c5c4878625f51ce109e2af4e80 ]

Make __qcom_scm_is_call_available() return bool instead of int. The
function has "is" in the name, so it should return a bool to indicate
the truth of the call being available. Unfortunately, it can return a
number < 0 which also looks "true", but not all callers expect that and
thus they think a call is available when really the check to see if the
call is available failed to figure it out.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Elliot Berman <eberman@codeaurora.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 0f206514749b ("scsi: firmware: qcom_scm: Add support for programming inline crypto keys")
Fixes: 0434a4061471 ("firmware: qcom: scm: add support to restore secure config to qcm_scm-32")
Fixes: b0a1614fb1f5 ("firmware: qcom: scm: add OCMEM lock/unlock interface")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210223214539.1336155-2-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 7be48c1bec96..54ba2834e763 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -113,9 +113,6 @@ static void qcom_scm_clk_disable(void)
 	clk_disable_unprepare(__scm->bus_clk);
 }
 
-static int __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
-					u32 cmd_id);
-
 enum qcom_scm_convention qcom_scm_convention;
 static bool has_queried __read_mostly;
 static DEFINE_SPINLOCK(query_lock);
@@ -219,8 +216,8 @@ static int qcom_scm_call_atomic(struct device *dev,
 	}
 }
 
-static int __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
-					u32 cmd_id)
+static bool __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
+					 u32 cmd_id)
 {
 	int ret;
 	struct qcom_scm_desc desc = {
@@ -247,7 +244,7 @@ static int __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
 
 	ret = qcom_scm_call(dev, &desc, &res);
 
-	return ret ? : res.result[0];
+	return ret ? false : !!res.result[0];
 }
 
 /**
@@ -585,9 +582,8 @@ bool qcom_scm_pas_supported(u32 peripheral)
 	};
 	struct qcom_scm_res res;
 
-	ret = __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_PIL,
-					   QCOM_SCM_PIL_PAS_IS_SUPPORTED);
-	if (ret <= 0)
+	if (!__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_PIL,
+					  QCOM_SCM_PIL_PAS_IS_SUPPORTED))
 		return false;
 
 	ret = qcom_scm_call(__scm->dev, &desc, &res);
@@ -1054,17 +1050,18 @@ EXPORT_SYMBOL(qcom_scm_ice_set_key);
  */
 bool qcom_scm_hdcp_available(void)
 {
+	bool avail;
 	int ret = qcom_scm_clk_enable();
 
 	if (ret)
 		return ret;
 
-	ret = __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_HDCP,
+	avail = __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_HDCP,
 						QCOM_SCM_HDCP_INVOKE);
 
 	qcom_scm_clk_disable();
 
-	return ret > 0;
+	return avail;
 }
 EXPORT_SYMBOL(qcom_scm_hdcp_available);
 
-- 
2.30.2



