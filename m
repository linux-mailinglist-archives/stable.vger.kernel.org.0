Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F570464458
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 02:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbhLABFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 20:05:00 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:4123 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236512AbhLABE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 20:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638320499; x=1669856499;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Tmns+pSWd50vLS9F74F2TuYEdYx1lfAxUZZYVCRGMt8=;
  b=TdoTIax1R+41ZQlMNr7XiRdt+AN3sBvKCgu4KzBMIRu66JoduMS575XG
   4o+OVuYm+Tp6dSY6xNaX1PuqgGTo9NE4et03Xcyc2MpEewoZJgMG2It6x
   1fwgefzZyQHtaWnyM3ikp1SMFggyCL0AI+Ncd58Dpqw9esHnhich2H7ym
   g=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 30 Nov 2021 17:01:39 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 17:01:39 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Tue, 30 Nov 2021 17:01:39 -0800
Received: from vivace-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Tue, 30 Nov 2021 17:01:38 -0800
From:   Bhaumik Bhatt <quic_bbhatt@quicinc.com>
To:     <manivannan.sadhasivam@linaro.org>
CC:     <linux-arm-msm@vger.kernel.org>, <quic_hemantk@quicinc.com>,
        <quic_jhugo@quicinc.com>, <linux-kernel@vger.kernel.org>,
        <mhi@lists.linux.dev>, <stable@vger.kernel.org>,
        <quic_olgak@quicinc.com>, <loic.poulain@linaro.org>,
        Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Subject: [PATCH v2] bus: mhi: core: Fix reading wake_capable channel configuration
Date:   Tue, 30 Nov 2021 17:01:31 -0800
Message-ID: <1638320491-13382-1-git-send-email-quic_bbhatt@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 'wake-capable' entry in channel configuration is not set when
parsing the configuration specified by the controller driver. Add
the missing entry to ensure channel is correctly specified as a
'wake-capable' channel.

Cc: stable@vger.kernel.org
Fixes: 0cbf260820fa ("bus: mhi: core: Add support for registering MHI controllers")
Signed-off-by: Bhaumik Bhatt <quic_bbhatt@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
 drivers/bus/mhi/core/init.c | 1 +
 1 file changed, 1 insertion(+)

v2:
-Update subject as per comments
-Add fixes tag and CC stable

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 5aaca6d..f1ec3441 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -788,6 +788,7 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
+		mhi_chan->wake_capable = ch_cfg->wake_capable;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction
-- 
2.7.4

