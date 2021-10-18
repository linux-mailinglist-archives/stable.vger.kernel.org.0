Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616A431E07
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhJRN5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhJRNzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE16F6139D;
        Mon, 18 Oct 2021 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564394;
        bh=aRWYbPLJdzMSYSxuiVXIJcGb6m+z+ik0PC3c3RYiH70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kju/ud2dOBkxrVrQZA6u8SWydnJAaA5VPpIqngaWAe1kvU5dtIq6FNRK4sVSKnN1W
         O1V99Gg8Pm2Mg0IDxzz57x7uHkm2780sCLNy8+Zi4oRJWK6t4xvyMzjZrnCdvCcwp3
         AgvcJn20rVmikONq6HGJGkA2r8fyzPWSIphRt2kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.14 039/151] mei: hbm: drop hbm responses on early shutdown
Date:   Mon, 18 Oct 2021 15:23:38 +0200
Message-Id: <20211018132341.963860480@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 6d7163f2c49fda5658e43105a96b555c89a4548d upstream.

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
Link: https://lore.kernel.org/r/20211013074552.2278419-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hbm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1298,7 +1298,8 @@ int mei_hbm_dispatch(struct mei_device *
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_STARTING) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: start: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1381,7 +1382,8 @@ int mei_hbm_dispatch(struct mei_device *
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_DR_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: dma setup response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1448,7 +1450,8 @@ int mei_hbm_dispatch(struct mei_device *
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: properties response: on shutdown, ignoring\n");
 				return 0;
 			}
@@ -1490,7 +1493,8 @@ int mei_hbm_dispatch(struct mei_device *
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_ENUM_CLIENTS) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: enumeration response: on shutdown, ignoring\n");
 				return 0;
 			}


