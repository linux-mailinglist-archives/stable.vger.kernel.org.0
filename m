Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83F249A027
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842055AbiAXXAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835946AbiAXWhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968ECC0E9BB5;
        Mon, 24 Jan 2022 13:00:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34F7360916;
        Mon, 24 Jan 2022 21:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080EFC340E5;
        Mon, 24 Jan 2022 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058002;
        bh=qWbXenzRRa+AVmkAUbR1x2EAU0jv0G6Wwnjuj0RyNZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYLSSztxDime/5P0sJkTujRg7aqg6W/Q/rOBTgTZsdLr2EOn497AkVIqgKjyj63NR
         WWTh3LjD54kYGUXV5jHtyIz5LVRNpwhKi0QgikfOA6bI2fZlKJKwK5fURJm+lOED9L
         E2p+1vsYEiU4PWO0X40Cm6aSB1ew29UlekiMUuQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0122/1039] media: atomisp: fix punit_ddr_dvfs_enable() argument for mrfld_power up case
Date:   Mon, 24 Jan 2022 19:31:51 +0100
Message-Id: <20220124184129.240398177@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit 5bfbf65fcca7325e4d89d289b3c286e11220e386 ]

When comparing with intel-aero atomisp [1], it looks like
punit_ddr_dvfs_enable() should take `false` as an argument on mrfld_power
up case.

Code from the intel-aero kernel [1]:

        int atomisp_mrfld_power_down(struct atomisp_device *isp)
        {
        [...]
		/*WA:Enable DVFS*/
		if (IS_CHT)
			punit_ddr_dvfs_enable(true);

        int atomisp_mrfld_power_up(struct atomisp_device *isp)
        {
        [...]
		/*WA for PUNIT, if DVFS enabled, ISP timeout observed*/
		if (IS_CHT)
			punit_ddr_dvfs_enable(false);

This patch fixes the inverted argument as per the intel-aero code, as
well as its comment. While here, fix space issues for comments in
atomisp_mrfld_power().

Note that it does not seem to be possible to unify the up/down cases for
punit_ddr_dvfs_enable(), i.e., we can't do something like the following:

        if (IS_CHT)
		punit_ddr_dvfs_enable(!enable);

because according to the intel-aero code [1], the DVFS is disabled
before "writing 0x0 to ISPSSPM0 bit[1:0]" and the DVFS is enabled after
"writing 0x3 to ISPSSPM0 bit[1:0]".

[1] https://github.com/intel-aero/linux-kernel/blob/a1b673258feb915268377275130c5c5df0eafc82/drivers/media/pci/atomisp/atomisp_driver/atomisp_v4l2.c#L431-L514

Fixes: 0f441fd70b1e ("media: atomisp: simplify the power down/up code")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index 0511c454e769d..7982cc143374a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -711,15 +711,15 @@ static int atomisp_mrfld_power(struct atomisp_device *isp, bool enable)
 
 	dev_dbg(isp->dev, "IUNIT power-%s.\n", enable ? "on" : "off");
 
-	/*WA:Enable DVFS*/
+	/* WA for P-Unit, if DVFS enabled, ISP timeout observed */
 	if (IS_CHT && enable)
-		punit_ddr_dvfs_enable(true);
+		punit_ddr_dvfs_enable(false);
 
 	/*
 	 * FIXME:WA for ECS28A, with this sleep, CTS
 	 * android.hardware.camera2.cts.CameraDeviceTest#testCameraDeviceAbort
 	 * PASS, no impact on other platforms
-	*/
+	 */
 	if (IS_BYT && enable)
 		msleep(10);
 
@@ -727,7 +727,7 @@ static int atomisp_mrfld_power(struct atomisp_device *isp, bool enable)
 	iosf_mbi_modify(BT_MBI_UNIT_PMC, MBI_REG_READ, MRFLD_ISPSSPM0,
 			val, MRFLD_ISPSSPM0_ISPSSC_MASK);
 
-	/*WA:Enable DVFS*/
+	/* WA:Enable DVFS */
 	if (IS_CHT && !enable)
 		punit_ddr_dvfs_enable(true);
 
-- 
2.34.1



