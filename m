Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19010B1ECE
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389249AbfIMNNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388194AbfIMNM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:12:58 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED87E206BB;
        Fri, 13 Sep 2019 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380377;
        bh=VB7Zdp1PbL+krmlgN8OW2KnVfoVMStM6wF5XK6l28+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqDkN8iDNiotOnFQYR8KmbAURPbw84RPq4HRwNNB22aG+HNov0QT/9RkTmkRcSP71
         YcJsQpzxmxNCCrDktXsJZmQed5atpvZsPbnfuj+tTpFAADkaUB4A6WG59ZLASzo7UR
         llAKU+0pWL5OuuibkYAyD0iVWgudQXTmidnTkkIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/190] remoteproc: qcom: q6v5: shore up resource probe handling
Date:   Fri, 13 Sep 2019 14:04:42 +0100
Message-Id: <20190913130601.804917211@linuxfoundation.org>
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

[ Upstream commit 1e2517d126171a41f801738ffd19687836cd178a ]

Commit d5269c4553a6 ("remoteproc: qcom: q6v5: Propagate EPROBE_DEFER")
fixed up our probe code to handle -EPROBE_DEFER, but it ignored one of
our interrupts, and it also didn't really handle all the other error
codes you might get (e.g., with a bad DT definition). Handle those all
explicitly.

Fixes: d5269c4553a6 ("remoteproc: qcom: q6v5: Propagate EPROBE_DEFER")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5.c | 44 +++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index e9ab90c19304f..602af839421de 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -188,6 +188,14 @@ int qcom_q6v5_init(struct qcom_q6v5 *q6v5, struct platform_device *pdev,
 	init_completion(&q6v5->stop_done);
 
 	q6v5->wdog_irq = platform_get_irq_byname(pdev, "wdog");
+	if (q6v5->wdog_irq < 0) {
+		if (q6v5->wdog_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to retrieve wdog IRQ: %d\n",
+				q6v5->wdog_irq);
+		return q6v5->wdog_irq;
+	}
+
 	ret = devm_request_threaded_irq(&pdev->dev, q6v5->wdog_irq,
 					NULL, q6v5_wdog_interrupt,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
@@ -198,8 +206,13 @@ int qcom_q6v5_init(struct qcom_q6v5 *q6v5, struct platform_device *pdev,
 	}
 
 	q6v5->fatal_irq = platform_get_irq_byname(pdev, "fatal");
-	if (q6v5->fatal_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (q6v5->fatal_irq < 0) {
+		if (q6v5->fatal_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to retrieve fatal IRQ: %d\n",
+				q6v5->fatal_irq);
+		return q6v5->fatal_irq;
+	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, q6v5->fatal_irq,
 					NULL, q6v5_fatal_interrupt,
@@ -211,8 +224,13 @@ int qcom_q6v5_init(struct qcom_q6v5 *q6v5, struct platform_device *pdev,
 	}
 
 	q6v5->ready_irq = platform_get_irq_byname(pdev, "ready");
-	if (q6v5->ready_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (q6v5->ready_irq < 0) {
+		if (q6v5->ready_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to retrieve ready IRQ: %d\n",
+				q6v5->ready_irq);
+		return q6v5->ready_irq;
+	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, q6v5->ready_irq,
 					NULL, q6v5_ready_interrupt,
@@ -224,8 +242,13 @@ int qcom_q6v5_init(struct qcom_q6v5 *q6v5, struct platform_device *pdev,
 	}
 
 	q6v5->handover_irq = platform_get_irq_byname(pdev, "handover");
-	if (q6v5->handover_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (q6v5->handover_irq < 0) {
+		if (q6v5->handover_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to retrieve handover IRQ: %d\n",
+				q6v5->handover_irq);
+		return q6v5->handover_irq;
+	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, q6v5->handover_irq,
 					NULL, q6v5_handover_interrupt,
@@ -238,8 +261,13 @@ int qcom_q6v5_init(struct qcom_q6v5 *q6v5, struct platform_device *pdev,
 	disable_irq(q6v5->handover_irq);
 
 	q6v5->stop_irq = platform_get_irq_byname(pdev, "stop-ack");
-	if (q6v5->stop_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (q6v5->stop_irq < 0) {
+		if (q6v5->stop_irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"failed to retrieve stop-ack IRQ: %d\n",
+				q6v5->stop_irq);
+		return q6v5->stop_irq;
+	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, q6v5->stop_irq,
 					NULL, q6v5_stop_interrupt,
-- 
2.20.1



