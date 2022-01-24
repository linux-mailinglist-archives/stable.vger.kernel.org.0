Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99882498F32
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242936AbiAXTvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59476 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345635AbiAXTi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 899F8B81250;
        Mon, 24 Jan 2022 19:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D27C33A1C;
        Mon, 24 Jan 2022 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053103;
        bh=n3NJfTp/Pp/vZAidsmeEXWJbiKjAhzMri3BOT8j4izQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb/TLW80kcVwjGSQZuZyX7NphQuOpdp2yrtV2ANz0G0P2rvkxbfVUXwrGi/4ND9vq
         BZbRm2aRqnLwbsQLIfOUkxUISQgsq+0gZicFZ36yLaqlm0zLh9zacCT5Orv/NSzpR3
         ourm7WXkjZzhdEabKKfQe7GWfkuplFp/jq2h3MuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.4 245/320] rpmsg: core: Clean up resources on announce_create failure.
Date:   Mon, 24 Jan 2022 19:43:49 +0100
Message-Id: <20220124184002.321537839@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

commit 8066c615cb69b7da8a94f59379847b037b3a5e46 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_core.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -473,13 +473,25 @@ static int rpmsg_dev_probe(struct device
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


