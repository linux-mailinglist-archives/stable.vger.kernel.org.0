Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B124C15EF10
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbgBNQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389407AbgBNQCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2252467C;
        Fri, 14 Feb 2020 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696156;
        bh=GcUOOjd60xaF7XZi3XOX5Tnm4Z0NAaWg+JkTfzDyX/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VocxCIWadXt394TZnxzQ0vFSXkJ1yIL+Mn1ioPfYVVvf4bmGIxMQQUApXGuCSjDgC
         9J55ykyWVBzCcAo2+hWldx4hVkAWGLJHkY/HzhY8BJrikR9fZL2I+G7sTbBZJwsFUV
         gel1JaAdccovnYgiOLA3xfUxVgQriZh0E25lj0/U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 035/459] media: ov5640: Fix check for PLL1 exceeding max allowed rate
Date:   Fri, 14 Feb 2020 10:54:45 -0500
Message-Id: <20200214160149.11681-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 18dd2d717088b..a398ea81e422b 100644
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

