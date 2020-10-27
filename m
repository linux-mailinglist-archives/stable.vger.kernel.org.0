Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FF29B77A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798432AbgJ0Pdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761420AbgJ0Pdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20AF72225E;
        Tue, 27 Oct 2020 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812817;
        bh=V6WCZhbYK8PM3SlyYU26MRyCWmQLC97n29Y1qJ48Kkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yu7foEcFrL7VuEl74uW1pQh5oYO5Yqseni5YyKXQosM20rxyJIuITlYTdpMwZfTA/
         GeeUHWauZU4jPY+NBcY4vVj9+MRkM/6gzyPJSKvhgZ4HnrP3m6NBXBd/yknOKorgN1
         V9bzqucu8Fzui6hwFnQ4m/Kxhb/oBf8MTGT0W1X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tingwei Zhang <tingwei@codeaurora.org>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 339/757] coresight: cti: Fix remove sysfs link error
Date:   Tue, 27 Oct 2020 14:49:49 +0100
Message-Id: <20201027135506.473379537@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 1cce921bce7dcf6fef9bdfa4dcc9406383274408 ]

CTI code to remove sysfs link to other devices on shutdown, incorrectly
tries to remove a single ended link when these are all double ended. This
implementation leaves elements in the link info structure undefined which
results in a crash in recent tests for driver module unload.

This patch corrects the link removal code.

Fixes: 73274abb6557 ("coresight: cti: Add in sysfs links to other coresight devices")
Reported-by: Tingwei Zhang <tingwei@codeaurora.org>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200928163513.70169-18-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti.c b/drivers/hwtracing/coresight/coresight-cti.c
index 47f3c9abae303..92aa535f9e134 100644
--- a/drivers/hwtracing/coresight/coresight-cti.c
+++ b/drivers/hwtracing/coresight/coresight-cti.c
@@ -494,12 +494,15 @@ static bool cti_add_sysfs_link(struct cti_drvdata *drvdata,
 	return !link_err;
 }
 
-static void cti_remove_sysfs_link(struct cti_trig_con *tc)
+static void cti_remove_sysfs_link(struct cti_drvdata *drvdata,
+				  struct cti_trig_con *tc)
 {
 	struct coresight_sysfs_link link_info;
 
+	link_info.orig = drvdata->csdev;
 	link_info.orig_name = tc->con_dev_name;
 	link_info.target = tc->con_dev;
+	link_info.target_name = dev_name(&drvdata->csdev->dev);
 	coresight_remove_sysfs_link(&link_info);
 }
 
@@ -590,7 +593,7 @@ void cti_remove_assoc_from_csdev(struct coresight_device *csdev)
 		ctidev = &ctidrv->ctidev;
 		list_for_each_entry(tc, &ctidev->trig_cons, node) {
 			if (tc->con_dev == csdev->ect_dev) {
-				cti_remove_sysfs_link(tc);
+				cti_remove_sysfs_link(ctidrv, tc);
 				tc->con_dev = NULL;
 				break;
 			}
@@ -634,7 +637,7 @@ static void cti_remove_conn_xrefs(struct cti_drvdata *drvdata)
 		if (tc->con_dev) {
 			coresight_set_assoc_ectdev_mutex(tc->con_dev,
 							 NULL);
-			cti_remove_sysfs_link(tc);
+			cti_remove_sysfs_link(drvdata, tc);
 			tc->con_dev = NULL;
 		}
 	}
-- 
2.25.1



