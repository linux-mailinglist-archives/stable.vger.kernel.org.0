Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A3542B96E
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 09:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhJMHsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 03:48:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:21694 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238509AbhJMHsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 03:48:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227657473"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="227657473"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:46:04 -0700
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="563016609"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:46:02 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: hbm: drop hbm responses on early shutdown
Date:   Wed, 13 Oct 2021 10:45:52 +0300
Message-Id: <20211013074552.2278419-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Drop HBM responses also in the early shutdown phase where
the usual traffic is allowed.
Extend the rule that drop HBM responses received during the shutdown phase
by also in MEI_DEV_POWERING_DOWN state.
This resolves the stall if the driver is stopping in the middle
of the link init or link reset.

Fixes: da3eb47c90d4 ("mei: hbm: drop hbm responses on shutdown")
Fixes: 36edb1407c3c ("mei: allow clients on bus to communicate in remove callback")
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 99b5c1ecc444..be41843df75b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1298,7 +1298,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_STARTING) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: start: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1381,7 +1382,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_DR_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: dma setup response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1448,7 +1450,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: properties response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1490,7 +1493,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_ENUM_CLIENTS) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: enumeration response: on shutdown, ignoring\n");
 				return 0;
 			}
-- 
2.31.1

