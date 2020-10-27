Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE329C062
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783540AbgJ0O6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753224AbgJ0O6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBA621527;
        Tue, 27 Oct 2020 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810702;
        bh=7fmBJzGZiOmKsDk6Xs1UcibBG3VXSFQ/JCpTpN8fJpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBBbEm15eLv1RC/rdGLf+pYSnYPMpeDhE3C/UU+dijTiWxfVuZ7PkFoi6DYjg0P8R
         vrpG+WCWNepYgwSxdjyiVVkQ1jLUfATFcCU4KcEpKLxZWJ0QhNkOQvz9uOsU68K4UH
         GlPGUxb1pZ2N8GjWtjnH9v0qK24wJc/m46A/4KMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Jonathan Zhou <jonathan.zhouwen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 233/633] coresight: etm4x: Fix issues within reset interface of sysfs
Date:   Tue, 27 Oct 2020 14:49:36 +0100
Message-Id: <20201027135533.613681578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Zhou <jonathan.zhouwen@huawei.com>

[ Upstream commit 4020fc8d4658dc1dbc27c5644bcb6254caa05e5e ]

The member @nr_addr_cmp is not a bool value, using operator '>'
instead to avoid unexpected failure.

Fixes: a77de2637c9e ("coresight: etm4x: moving sysFS entries to a dedicated file")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Jonathan Zhou <jonathan.zhouwen@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-9-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index b673e738bc9a8..a588cd6de01c7 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -206,7 +206,7 @@ static ssize_t reset_store(struct device *dev,
 	 * each trace run.
 	 */
 	config->vinst_ctrl = BIT(0);
-	if (drvdata->nr_addr_cmp == true) {
+	if (drvdata->nr_addr_cmp > 0) {
 		config->mode |= ETM_MODE_VIEWINST_STARTSTOP;
 		/* SSSTATUS, bit[9] */
 		config->vinst_ctrl |= BIT(9);
-- 
2.25.1



