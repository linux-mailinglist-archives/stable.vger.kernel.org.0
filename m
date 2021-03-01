Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3331C328812
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbhCARci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238413AbhCAR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C8D65084;
        Mon,  1 Mar 2021 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617454;
        bh=WKgHO+1yfE8Ozk+2fuc9rhDhEjR2FGxWetxkSwRtA4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVhIxxmFmzAatsbp7gdaJBGucHrppqYUS07brPEcrU2aFkVK1cNWLzpbhigHRgY+/
         7YdqIx9VusRbIeSpAYzcj46P6cVQRuAeC1agnMEtZHyqCaX2Mn8yh2/9sQedOFYlKZ
         wuEwHtB72TzLBBkQvWl3UY1nvvWhAtc30Pph7Rpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/340] media: i2c: ov5670: Fix PIXEL_RATE minimum value
Date:   Mon,  1 Mar 2021 17:10:24 +0100
Message-Id: <20210301161052.260902097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 041fcbb4eebdf..79e608dba4b6d 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2081,7 +2081,8 @@ static int ov5670_init_controls(struct ov5670 *ov5670)
 
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



