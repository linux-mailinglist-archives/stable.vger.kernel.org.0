Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA82126BEC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfLSTAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbfLSSwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA02222C2;
        Thu, 19 Dec 2019 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781552;
        bh=YhMsg1iYzqKsOGy/17yoIbmWQ5/wgTOI3xyj9vtrgYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYEUJRQuYgfb6J90uhrUORPNsw93YGVK+ZQSal57vIUHioOI9nok+uAGuSxdLaWNI
         a+tbdLNpaJ8/bShAlj1GNPh0RdJGG0pfeZ73fJZczUVgMmmTf0i6T4j+Ra1yYLnj5V
         z3vjjI6o9H3/kh6baG1jeV9x2Kb9dkMhc4NwZhkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.19 30/47] rpmsg: glink: Free pending deferred work on remove
Date:   Thu, 19 Dec 2019 19:34:44 +0100
Message-Id: <20191219182934.163082126@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 278bcb7300f61785dba63840bd2a8cf79f14554c upstream.

By just cancelling the deferred rx worker during GLINK instance teardown
any pending deferred commands are leaked, so free them.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Cc: stable@vger.kernel.org
Acked-by: Chris Lew <clew@codeaurora.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1565,6 +1565,18 @@ static void qcom_glink_work(struct work_
 	}
 }
 
+static void qcom_glink_cancel_rx_work(struct qcom_glink *glink)
+{
+	struct glink_defer_cmd *dcmd;
+	struct glink_defer_cmd *tmp;
+
+	/* cancel any pending deferred rx_work */
+	cancel_work_sync(&glink->rx_work);
+
+	list_for_each_entry_safe(dcmd, tmp, &glink->rx_queue, node)
+		kfree(dcmd);
+}
+
 struct qcom_glink *qcom_glink_native_probe(struct device *dev,
 					   unsigned long features,
 					   struct qcom_glink_pipe *rx,
@@ -1642,7 +1654,7 @@ void qcom_glink_native_remove(struct qco
 	int ret;
 
 	disable_irq(glink->irq);
-	cancel_work_sync(&glink->rx_work);
+	qcom_glink_cancel_rx_work(glink);
 
 	ret = device_for_each_child(glink->dev, NULL, qcom_glink_remove_device);
 	if (ret)


