Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14A34A4502
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351219AbiAaLft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376986AbiAaLcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B7BC0604CB;
        Mon, 31 Jan 2022 03:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D0C0B82A66;
        Mon, 31 Jan 2022 11:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936C1C340E8;
        Mon, 31 Jan 2022 11:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628111;
        bh=zq0eIqyEOraPAsidksoElf7gEdCbjdbpAhnUeeYukTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEgZCusmyeFjGePPuDzLFacT88J2wNspfxsEIH2g7DIzOEt3dx6mML/64YJ7fmaYB
         RPT+/DDTCqTQyjggqKTnkvAnqZqVKEwFN/dXt0nkyAeW+nhuNeLuBhTG+X7eIWn46L
         IJDUftr/sSVLBm1BzhivAhpL08QXNd1LK7KFtdk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-remoteproc@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 127/200] remoteproc: qcom: q6v5: fix service routines build errors
Date:   Mon, 31 Jan 2022 11:56:30 +0100
Message-Id: <20220131105237.835248185@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit eee412e968f7b950564880bc6a7a9f00f49034da ]

When CONFIG_QCOM_AOSS_QMP=m and CONFIG_QCOM_Q6V5_MSS=y, the builtin
driver cannot call into the loadable module's low-level service
functions. Trying to build with that config combo causes linker errors.

There are two problems here. First, drivers/remoteproc/qcom_q6v5.c
should #include <linux/soc/qcom/qcom_aoss.h> for the definitions of
the service functions, depending on whether CONFIG_QCOM_AOSS_QMP is
set/enabled or not. Second, the qcom remoteproc drivers should depend
on QCOM_AOSS_QMP iff it is enabled (=y or =m) so that the qcom
remoteproc drivers can be built properly.

This prevents these build errors:

aarch64-linux-ld: drivers/remoteproc/qcom_q6v5.o: in function `q6v5_load_state_toggle':
qcom_q6v5.c:(.text+0xc4): undefined reference to `qmp_send'
aarch64-linux-ld: drivers/remoteproc/qcom_q6v5.o: in function `qcom_q6v5_deinit':
(.text+0x2e4): undefined reference to `qmp_put'
aarch64-linux-ld: drivers/remoteproc/qcom_q6v5.o: in function `qcom_q6v5_init':
(.text+0x778): undefined reference to `qmp_get'
aarch64-linux-ld: (.text+0x7d8): undefined reference to `qmp_put'

Fixes: c1fe10d238c0 ("remoteproc: qcom: q6v5: Use qmp_send to update co-processor load state")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-remoteproc@vger.kernel.org
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220115011338.2973-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/Kconfig     | 4 ++++
 drivers/remoteproc/qcom_q6v5.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index f2e961f998ca2..341156e2a29b9 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -180,6 +180,7 @@ config QCOM_Q6V5_ADSP
 	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
 	depends on QCOM_SYSMON || QCOM_SYSMON=n
 	depends on RPMSG_QCOM_GLINK || RPMSG_QCOM_GLINK=n
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select MFD_SYSCON
 	select QCOM_PIL_INFO
 	select QCOM_MDT_LOADER
@@ -199,6 +200,7 @@ config QCOM_Q6V5_MSS
 	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
 	depends on QCOM_SYSMON || QCOM_SYSMON=n
 	depends on RPMSG_QCOM_GLINK || RPMSG_QCOM_GLINK=n
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_PIL_INFO
@@ -218,6 +220,7 @@ config QCOM_Q6V5_PAS
 	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
 	depends on QCOM_SYSMON || QCOM_SYSMON=n
 	depends on RPMSG_QCOM_GLINK || RPMSG_QCOM_GLINK=n
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select MFD_SYSCON
 	select QCOM_PIL_INFO
 	select QCOM_MDT_LOADER
@@ -239,6 +242,7 @@ config QCOM_Q6V5_WCSS
 	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
 	depends on QCOM_SYSMON || QCOM_SYSMON=n
 	depends on RPMSG_QCOM_GLINK || RPMSG_QCOM_GLINK=n
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_PIL_INFO
diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index eada7e34f3af5..442a388f81028 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -10,6 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/soc/qcom/qcom_aoss.h>
 #include <linux/soc/qcom/smem.h>
 #include <linux/soc/qcom/smem_state.h>
 #include <linux/remoteproc.h>
-- 
2.34.1



