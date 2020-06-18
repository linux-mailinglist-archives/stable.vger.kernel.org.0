Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F71FE157
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgFRByH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbgFRB0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE4021D7F;
        Thu, 18 Jun 2020 01:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443568;
        bh=PYgYh5EClCZLJSgI9EwuJGo8e/rRyeyZ+97SNn09/1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcWiJ3z3tVo1uV5mmprDD8oBu+41zhigyxTU7GStXh5GFnOpNM1Z9jbMRIF1J9Ne4
         zjHLOTWuWKtxwV8wE2UAQ75qWD/hv7cFQ4T0e5bwqaAxMBeq1gh965J5iv8uF/GAEg
         u/RuJw75UsBhHh5soCX7PtewYRz0oCLZAE/tUHZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 006/108] remoteproc: Fix IDR initialisation in rproc_alloc()
Date:   Wed, 17 Jun 2020 21:24:18 -0400
Message-Id: <20200618012600.608744-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 6442df49400b466431979e7634849a464a5f1861 ]

If ida_simple_get() returns an error when called in rproc_alloc(),
put_device() is called to clean things up.  By this time the rproc
device type has been assigned, with rproc_type_release() as the
release function.

The first thing rproc_type_release() does is call:
    idr_destroy(&rproc->notifyids);

But at the time the ida_simple_get() call is made, the notifyids
field in the remoteproc structure has not been initialized.

I'm not actually sure this case causes an observable problem, but
it's incorrect.  Fix this by initializing the notifyids field before
calling ida_simple_get() in rproc_alloc().

Fixes: b5ab5e24e960 ("remoteproc: maintain a generic child device for each rproc")
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200415204858.2448-2-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8f4fa1a52f05..d6372470e5be 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1432,6 +1432,7 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	rproc->dev.type = &rproc_type;
 	rproc->dev.class = &rproc_class;
 	rproc->dev.driver_data = rproc;
+	idr_init(&rproc->notifyids);
 
 	/* Assign a unique device index and name */
 	rproc->index = ida_simple_get(&rproc_dev_index, 0, 0, GFP_KERNEL);
@@ -1450,8 +1451,6 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 
 	mutex_init(&rproc->lock);
 
-	idr_init(&rproc->notifyids);
-
 	INIT_LIST_HEAD(&rproc->carveouts);
 	INIT_LIST_HEAD(&rproc->mappings);
 	INIT_LIST_HEAD(&rproc->traces);
-- 
2.25.1

