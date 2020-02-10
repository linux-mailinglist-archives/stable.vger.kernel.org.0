Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B51157569
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgBJMkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728299AbgBJMkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:45 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 180862467D;
        Mon, 10 Feb 2020 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338445;
        bh=0kGnIQmYHLHLyFnEWBAylLFxR0+B2VN0YAnNjlZp0IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzElSbxd5x3YMDS5phrGTxOY48tvQdZ11uBSsLlf1DB5POY9KFLftlJxIl48vDIRc
         UZQgs7NOg22hyiQVm28AsETYQn97FHfUYE6T1zrIv/LWtORoFGIuqBkvUudcznVpHf
         uXr3Pt6ZLgAtJg8HrWQQlUN8n7UTV4wmoY/DonCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 186/367] crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill
Date:   Mon, 10 Feb 2020 04:31:39 -0800
Message-Id: <20200210122441.826444883@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 7f8c36fe9be46862c4f3c5302f769378028a34fa upstream.

Since tasklet is needed to be initialized before registering IRQ
handler, adjust the position of tasklet_init to fix the wrong order.

Besides, to fix the missed tasklet_kill, this patch adds a helper
function and uses devm_add_action to kill the tasklet automatically.

Fixes: ce92136843cb ("crypto: picoxcell - add support for the picoxcell crypto engines")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/picoxcell_crypto.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1595,6 +1595,11 @@ static const struct of_device_id spacc_o
 MODULE_DEVICE_TABLE(of, spacc_of_id_table);
 #endif /* CONFIG_OF */
 
+static void spacc_tasklet_kill(void *data)
+{
+	tasklet_kill(data);
+}
+
 static int spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret;
@@ -1637,6 +1642,14 @@ static int spacc_probe(struct platform_d
 		return -ENXIO;
 	}
 
+	tasklet_init(&engine->complete, spacc_spacc_complete,
+		     (unsigned long)engine);
+
+	ret = devm_add_action(&pdev->dev, spacc_tasklet_kill,
+			      &engine->complete);
+	if (ret)
+		return ret;
+
 	if (devm_request_irq(&pdev->dev, irq->start, spacc_spacc_irq, 0,
 			     engine->name, engine)) {
 		dev_err(engine->dev, "failed to request IRQ\n");
@@ -1694,8 +1707,6 @@ static int spacc_probe(struct platform_d
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight = 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
 
 	platform_set_drvdata(pdev, engine);
 


