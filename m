Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB722B43D4
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgKPMgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 07:36:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728329AbgKPMgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 07:36:00 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGCU5v1022152;
        Mon, 16 Nov 2020 04:35:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=bMiMF6bHUEJrWeAPNW+vYTur1i8lIXjWzs+JyUKd0jo=;
 b=WILndzDaEHmtt7ZMcCL1eNEq3zw01ROj5f6S1aHkn5Vx6MoX2s9dWrsWxZ1RamwE7d5w
 cgpzteeynboUbSsa49g/4O2YFiaFcsXBTGSvCxpxsGl5lx9HgC+MCKE5hYyfycLnJKR4
 9lg0+hgmChVBcLIEySd2v1se+gMmE3sU6/JfhjJFlSUoUGJ41MxNgbTfJepm18nTBVBE
 n7Mlyh24tTB7utKleP0lSJfl0uGGvys4ZxN6IywckkFy0bLlCwI7l+Cx+DzU6MJqTeVQ
 FI7cyuPnLOt9uuGI8r+Ac1mOfVAvV8xL/+WQECi1XSeijLk+RNDf6CTBQ4njitGE/yrE Bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfmscxcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 04:35:49 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 04:35:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 04:35:47 -0800
Received: from virtx40.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 04:35:44 -0800
From:   Linu Cherian <lcherian@marvell.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <mathieu.poirier@linaro.org>, <suzuki.poulose@arm.com>,
        <mike.leach@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <coresight@lists.linaro.org>, <linuc.decode@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH stable-v5.9 2/2] coresight: Fix uninitialised pointer bug in etm_setup_aux()
Date:   Mon, 16 Nov 2020 18:05:10 +0530
Message-ID: <20201116123510.28980-2-lcherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201116123510.28980-1-lcherian@marvell.com>
References: <20201116123510.28980-1-lcherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_05:2020-11-13,2020-11-16 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

commit 39a7661dcf655c8198fd5d72412f5030a8e58444 upstream.

Commit [bb1860efc817] changed the sink handling code introducing an
uninitialised pointer bug. This results in the default sink selection
failing.

Prior to commit:

static void etm_setup_aux(...)

<snip>
        struct coresight_device *sink;
<snip>

        /* First get the selected sink from user space. */
        if (event->attr.config2) {
                id = (u32)event->attr.config2;
                sink = coresight_get_sink_by_id(id);
        } else {
                sink = coresight_get_enabled_sink(true);
        }
<ctd>

*sink always initialised - possibly to NULL which triggers the
automatic sink selection.

After commit:

static void etm_setup_aux(...)

<snip>
        struct coresight_device *sink;
<snip>

        /* First get the selected sink from user space. */
        if (event->attr.config2) {
                id = (u32)event->attr.config2;
                sink = coresight_get_sink_by_id(id);
        }
<ctd>

*sink pointer uninitialised when not providing a sink on the perf command
line. This breaks later checks to enable automatic sink selection.

Fixes: bb1860efc817 ("coresight: etm: perf: Sink selection using sysfs is deprecated")
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201029164559.1268531-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 75379184f391..9a8d03e62a75 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -210,7 +210,7 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 	u32 id;
 	int cpu = event->cpu;
 	cpumask_t *mask;
-	struct coresight_device *sink;
+	struct coresight_device *sink = NULL;
 	struct etm_event_data *event_data = NULL;
 
 	event_data = alloc_event_data(cpu);
-- 
2.25.1

