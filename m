Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424DB15F14B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgBNSBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387731AbgBNP4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8EB222C4;
        Fri, 14 Feb 2020 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695777;
        bh=+0812Eg5+LNOtMVydZcCyoOxN83vHjF8PnFw8dcCjhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5H1XIABIJSH4EbemufsniTFeM7z0sdVGI5LAkDWW4MzfJ+vq/XwSG43Ofo06K0te
         H/bo5gxpFnHrH/apBczsAuSa+QWbdNUkbfHQCN1mUYRootXP32IStHpOnAEIWZhlNg
         /7vHQ1tTo0XKXykkZs1WT2xhOdWeG6FBkTZEzOTA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        kbuild test robot <lkp@intel.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 342/542] bus: fsl-mc: properly empty-initialize structure
Date:   Fri, 14 Feb 2020 10:45:34 -0500
Message-Id: <20200214154854.6746-342-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit cff081ea9d0962defd733daf6778f62b1dac3daa ]

Use the proper form of the empty initializer when working with
structures that contain an array. Otherwise, older gcc versions (eg gcc
4.9) will complain about this.

Fixes: 1ac210d128ef ("bus: fsl-mc: add the fsl_mc_get_endpoint function")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Link: https://lore.kernel.org/r/20191204142950.30206-1-ioana.ciornei@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index a07cc19becdba..c78d10ea641fb 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -715,9 +715,9 @@ EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
 struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
 {
 	struct fsl_mc_device *mc_bus_dev, *endpoint;
-	struct fsl_mc_obj_desc endpoint_desc = { 0 };
-	struct dprc_endpoint endpoint1 = { 0 };
-	struct dprc_endpoint endpoint2 = { 0 };
+	struct fsl_mc_obj_desc endpoint_desc = {{ 0 }};
+	struct dprc_endpoint endpoint1 = {{ 0 }};
+	struct dprc_endpoint endpoint2 = {{ 0 }};
 	int state, err;
 
 	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
-- 
2.20.1

