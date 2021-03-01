Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D17C328EA5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242032AbhCATef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241862AbhCAT3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A568C65016;
        Mon,  1 Mar 2021 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618639;
        bh=spGK3US/JfqH0Sh6+blfwSJoUcmkSbTXtspheQZBLfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaV4denbMA+w6MD+z08DDEeYN8N6dK2Pb5SiD8fDg7sfMIcyX0x9QhattqN8VrIus
         I+Ef+DWFrp9wyCrJfu1kviSX65SXIi7U9F3UiUPgcGvABsLplS1fMIpMGfVk3p/3AK
         TkAtkxNMcjdTm0cG7vuyh13bufPRD3Oc1ujYVCNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/663] media: i2c: ov5670: Fix PIXEL_RATE minimum value
Date:   Mon,  1 Mar 2021 17:06:48 +0100
Message-Id: <20210301161149.689754286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo@jmondi.org>

[ Upstream commit dc1eb7c9c290cba52937c9a224b22a400bb0ffd7 ]

The driver currently reports a single supported value for
V4L2_CID_PIXEL_RATE and initializes the control's minimum value to 0,
which is very risky, as userspace might accidentally use it as divider
when calculating the time duration of a line.

Fix this by using as minimum the only supported value when registering
the control.

Fixes: 5de35c9b8dcd1 ("media: i2c: Add Omnivision OV5670 5M sensor support")
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5670.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index f26252e35e08d..04d3f14902017 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2084,7 +2084,8 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 
 	/* By default, V4L2_CID_PIXEL_RATE is read only */
 	ov5670->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov5670_ctrl_ops,
-					       V4L2_CID_PIXEL_RATE, 0,
+					       V4L2_CID_PIXEL_RATE,
+					       link_freq_configs[0].pixel_rate,
 					       link_freq_configs[0].pixel_rate,
 					       1,
 					       link_freq_configs[0].pixel_rate);
-- 
2.27.0



