Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5753E98C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiFFOmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbiFFOmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:42:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED971CFEA;
        Mon,  6 Jun 2022 07:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654526561; x=1686062561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OqoppYmD9jzStHQaJl4xc14/rvjE1zzAYyvvKB5K9XU=;
  b=kL66s/R1VBxy4vRwCfI5eyw6OpDi3e8RRlaRd+5g+ZV2aRdG6eFitV0p
   CuqleRu7IiXa8qFgxFEiIYYN3Z1mgBOHU18PRoAO7D0dBL6554MI4T0N/
   3w1X6Id2glMJ+x7eLCyFhGH/EY+8ch7HkPs8TEMtZPK9QFx8mAUFSw40E
   a/W0JnKKegG434bZJ9/8K0Y1psFsPIT9JmFqha07qvqHeUNBX7ZnuZ2/b
   2WNW1EU5aZSnkzI2pY5SWp4uZ6g9BnG6oSrq4yAf3DqriE/WF1YRxHnZ/
   GwVT6i+pDWu0XSkk9Cl3osEvDM20Qbo3avpS9I1YOMzT/64DDJ+pqUjEY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="256497763"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="256497763"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 07:42:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="906574480"
Received: from twinkler-lnx.jer.intel.com ([10.12.87.143])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 07:42:39 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: hbm: drop capability response on early shutdown
Date:   Mon,  6 Jun 2022 17:42:24 +0300
Message-Id: <20220606144225.282375-2-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606144225.282375-1-tomas.winkler@intel.com>
References: <20220606144225.282375-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Drop HBM responses also in the early shutdown phase where
the usual traffic is allowed.
Extend the rule that drop HBM responses received during the shutdown
phase by also in MEI_DEV_POWERING_DOWN state.
This resolves the stall if the driver is stopping in the middle
of the link initialization or link reset.

Drop the capabilities response on early shutdown.

Fixes: 6d7163f2c49f ("mei: hbm: drop hbm responses on early shutdown")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index cebcca6d6d3e..cf2b8261da14 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1351,7 +1351,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CAP_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: capabilities response: on shutdown, ignoring\n");
 				return 0;
 			}
-- 
2.35.3

