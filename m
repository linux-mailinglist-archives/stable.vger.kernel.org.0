Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3240AB1EC2
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389178AbfIMNMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389173AbfIMNMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:12:34 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9B3214AF;
        Fri, 13 Sep 2019 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380353;
        bh=npITvHoRuo/dc7q/atfoPZwYGNwMxYGXtDpExq3wcWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymyzn/7oWeQKIvsiISpx3ATNr9m7unCwLxQTNnrlc4BGC5a4RGgj48hTNRjy82IkK
         z1D671XGVzzqPmBMZjqNCEADD5zDAIZqfjmwDTcSZOp9CSWWzRN+NcEjDLWoS/ZmOB
         grBlOfTEzivIBPH6gSHDC680fw1u+c+t7wJygwiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/190] remoteproc: qcom: q6v5-mss: add SCM probe dependency
Date:   Fri, 13 Sep 2019 14:04:52 +0100
Message-Id: <20190913130602.656270150@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



