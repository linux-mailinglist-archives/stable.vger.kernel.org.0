Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED80246A1E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgHQPac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbgHQPaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D877C20674;
        Mon, 17 Aug 2020 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678230;
        bh=3NJsjnywdLs82ViXItXubO00zUOfwlMyKJD63NnK0Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2tJ230ooluEcozfhOWwtUVcDqdB8HTxuB8yKNfzcC950z6G+SjOZ+BD2YifVWBhv
         K3FLeqsPdmK8JTngIShXRphUXoKPFrLI9dSLCg598M/EJk+40NFLcn4UNdS6881n7+
         QdpDemJ+K4mj+8aJitkYORxmY3PX/qn59T1owOt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 263/464] coresight: etmv4: Counter values not saved on disable
Date:   Mon, 17 Aug 2020 17:13:36 +0200
Message-Id: <20200817143846.387233751@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 8fa43700f69703f995ea715b76be6fabdd2f05de ]

The counter value registers change during operation, however this change
is not reflected in the values seen by the user in sysfs.

This fixes the issue by reading back the values on disable.

Signed-off-by: Mike Leach <mike.leach@linaro.org>
Fixes: 2e1cdfe184b52 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200716175746.3338735-11-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 0c35cd5e0d1d9..007d7c6e91f48 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -507,6 +507,12 @@ static void etm4_disable_hw(void *info)
 			readl_relaxed(drvdata->base + TRCSSCSRn(i));
 	}
 
+	/* read back the current counter values */
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		config->cntr_val[i] =
+			readl_relaxed(drvdata->base + TRCCNTVRn(i));
+	}
+
 	coresight_disclaim_device_unlocked(drvdata->base);
 
 	CS_LOCK(drvdata->base);
-- 
2.25.1



