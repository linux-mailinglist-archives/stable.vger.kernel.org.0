Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ED215F477
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgBNPtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbgBNPts (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA69024687;
        Fri, 14 Feb 2020 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695387;
        bh=t+HGHp5WXwS0C0Tt94knmpE+cBtGP+NH5K22SJzMyk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9Rj5+TbIsaYB1zcl28a1H9bKzZHti3x0xoI3BoUiuYnKeX+eD28W/ga3P1kffQyq
         0KvdrJhuIklIL+x2XJWyY99lC94ZSRMfSSixmD2mJWVhtUIstYgC031KY9DX2gbtWu
         JxVJKm9Wqu4i4JQ/VXvk52X+vFF6PadtOAZ+Po6s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 041/542] media: ov5640: Fix check for PLL1 exceeding max allowed rate
Date:   Fri, 14 Feb 2020 10:40:33 -0500
Message-Id: <20200214154854.6746-41-sashal@kernel.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2e3df204f9af42a47823ee955c08950373417420 ]

The variable _rate is by ov5640_compute_sys_clk() which returns
zero if the PLL exceeds 1GHz.  Unfortunately, the check to see
if the max PLL1 output is checking 'rate' and not '_rate' and
'rate' does not ever appear to be 0.

This patch changes the check against the returned value of
'_rate' to determine if the PLL1 output exceeds 1GHz.

Fixes: aa2882481cad ("media: ov5640: Adjust the clock based on the expected rate")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5e495c833d329..bb968e764f318 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -874,7 +874,7 @@ static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
 			 * We have reached the maximum allowed PLL1 output,
 			 * increase sysdiv.
 			 */
-			if (!rate)
+			if (!_rate)
 				break;
 
 			/*
-- 
2.20.1

