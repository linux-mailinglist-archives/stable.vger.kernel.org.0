Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B376F4992
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbfKHLmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389903AbfKHLmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6707B21D6C;
        Fri,  8 Nov 2019 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213339;
        bh=fTe/6jv6vp2P2ZrGxFtNky6NeEAfIueFoy7sJP/UR2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RU+WiYFUhi7UOyIS8iO3dGbs9Pm8dsuZkGxbCdQdmAg4D+29pMwp8bqVycVjoT1Gf
         b1JaAAijy4FVThgFzhq1LwcH2dTT8ogt4Fy5Q5CJps0v3lKQcM1BXy0zAhdCjAIAoD
         ff7u9ZPcViGjETKgcgNlNVs9xHNZwzSJrWS5Ycn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 176/205] soc: qcom: wcnss_ctrl: Avoid string overflow
Date:   Fri,  8 Nov 2019 06:37:23 -0500
Message-Id: <20191108113752.12502-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 4c96ed170d658d8826d94edec8ac93ee777981a2 ]

'chinfo.name' is used as a NUL-terminated string, but using strncpy() with
the length equal to the buffer size may result in lack of the termination:

drivers//soc/qcom/wcnss_ctrl.c: In function 'qcom_wcnss_open_channel':
drivers//soc/qcom/wcnss_ctrl.c:284:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  strncpy(chinfo.name, name, sizeof(chinfo.name));
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This changes it to use the safer strscpy() instead.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/wcnss_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/wcnss_ctrl.c b/drivers/soc/qcom/wcnss_ctrl.c
index df3ccb30bc2dd..373400dd816d6 100644
--- a/drivers/soc/qcom/wcnss_ctrl.c
+++ b/drivers/soc/qcom/wcnss_ctrl.c
@@ -281,7 +281,7 @@ struct rpmsg_endpoint *qcom_wcnss_open_channel(void *wcnss, const char *name, rp
 	struct rpmsg_channel_info chinfo;
 	struct wcnss_ctrl *_wcnss = wcnss;
 
-	strncpy(chinfo.name, name, sizeof(chinfo.name));
+	strscpy(chinfo.name, name, sizeof(chinfo.name));
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = RPMSG_ADDR_ANY;
 
-- 
2.20.1

