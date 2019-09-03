Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CA5A6E55
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbfICQZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbfICQZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E0223717;
        Tue,  3 Sep 2019 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527935;
        bh=oe14+vK7P/AQ7RwNiioO7YAGtQb2g3lvNAJHcLJkzbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G92S1SiwuvDhRSBsQM4B5a5IsA+mWu5wpOQXScd58JnlMob81hYdeOU7Jjj72HFvk
         KUVmBXvCEhsgvqSvgcVJshUiIxwMa/yGBapn1rc/UUM0lM6ORyH312RcHfNk7kguov
         2TsNRWHG3ZYisdzZc0gUwK77wq4R0to0kjiQD4LY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 008/167] remoteproc: qcom: q6v5-mss: add SCM probe dependency
Date:   Tue,  3 Sep 2019 12:22:40 -0400
Message-Id: <20190903162519.7136-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit bbcda30271752bb7490f2e2aef5411dbcae69116 ]

The memory ownership transfer request is performed using SCM, ensure
that SCM is available before we probe the driver if memory protection is
needed by the subsystem.

Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
Cc: stable@vger.kernel.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bjorn: Added condition for need_mem_protection, updated commit message]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pil.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pil.c b/drivers/remoteproc/qcom_q6v5_pil.c
index d7a4b9eca5d25..6a84b6372897d 100644
--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -1132,6 +1132,9 @@ static int q6v5_probe(struct platform_device *pdev)
 	if (!desc)
 		return -EINVAL;
 
+	if (desc->need_mem_protection && !qcom_scm_is_available())
+		return -EPROBE_DEFER;
+
 	rproc = rproc_alloc(&pdev->dev, pdev->name, &q6v5_ops,
 			    desc->hexagon_mba_image, sizeof(*qproc));
 	if (!rproc) {
-- 
2.20.1

