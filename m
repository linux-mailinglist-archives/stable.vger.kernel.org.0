Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE73C4972DF
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiAWQJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:09:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42692 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiAWQJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:09:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D8BB80DD1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0694FC340E2;
        Sun, 23 Jan 2022 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642954175;
        bh=C6TsRQJwZ1QTDpGME55jl1IQzkPIbHd8BMBjAI3h9Dw=;
        h=Subject:To:Cc:From:Date:From;
        b=zRalJGejNkA8wKrhM6MqiChsOWGSnIMgY3El08noBD4kwQXlgEUqzZ6Xlj2P88e92
         cmk/hQPGllHEBV8plT4wRZFMsWUXvhRceIQXRxYAcegEYl+3RwRslgh0K4rWz4PKwK
         J7R1LYRMnDaFhlyNT5fu5sQbbk/OUab7ooAQ1txU=
Subject: FAILED: patch "[PATCH] rpmsg: core: Clean up resources on announce_create failure." failed to apply to 4.19-stable tree
To:     arnaud.pouliquen@foss.st.com, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:09:22 +0100
Message-ID: <164295416216567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8066c615cb69b7da8a94f59379847b037b3a5e46 Mon Sep 17 00:00:00 2001
From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Date: Mon, 6 Dec 2021 20:07:58 +0100
Subject: [PATCH] rpmsg: core: Clean up resources on announce_create failure.

During the rpmsg_dev_probe, if rpdev->ops->announce_create returns an
error, the rpmsg device and default endpoint should be freed before
exiting the function.

Fixes: 5e619b48677c ("rpmsg: Split rpmsg core and virtio backend")
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211206190758.10004-1-arnaud.pouliquen@foss.st.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index f031b2b1b21c..d9e612f4f0f2 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -540,13 +540,25 @@ static int rpmsg_dev_probe(struct device *dev)
 	err = rpdrv->probe(rpdev);
 	if (err) {
 		dev_err(dev, "%s: failed: %d\n", __func__, err);
-		if (ept)
-			rpmsg_destroy_ept(ept);
-		goto out;
+		goto destroy_ept;
 	}
 
-	if (ept && rpdev->ops->announce_create)
+	if (ept && rpdev->ops->announce_create) {
 		err = rpdev->ops->announce_create(rpdev);
+		if (err) {
+			dev_err(dev, "failed to announce creation\n");
+			goto remove_rpdev;
+		}
+	}
+
+	return 0;
+
+remove_rpdev:
+	if (rpdrv->remove)
+		rpdrv->remove(rpdev);
+destroy_ept:
+	if (ept)
+		rpmsg_destroy_ept(ept);
 out:
 	return err;
 }

