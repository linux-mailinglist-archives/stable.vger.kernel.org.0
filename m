Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19913EC0F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405926AbgAPRom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405921AbgAPRok (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CCA72476C;
        Thu, 16 Jan 2020 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196680;
        bh=rrQA1snCfmDy871NRKpV7w6EV7gvXWUXGcNDfLJ3rFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRGSgub4dbHjMA8XOwHkZVOKzVmaqrvPgWnfaFLHbsIgw50RF0B/ikalC3+BolgsH
         uhzHBBfk6Qk5SlR4YXs8/E6KSWChICqzgKJa3NAHIStX/tE7Bogh91vMWL1p+bMEud
         D+06KozpRQABgPx9XCBjIi9KB0zS2ry86kIEiu44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        "Lad Prabhakar" <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 078/174] media: ov2659: fix unbalanced mutex_lock/unlock
Date:   Thu, 16 Jan 2020 12:41:15 -0500
Message-Id: <20200116174251.24326-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 384538bda10913e5c94ec5b5d34bd3075931bcf4 ]

Avoid returning with mutex locked.

Fixes: fa8cb6444c32 ("[media] ov2659: Don't depend on subdev API")

Cc: "Lad Prabhakar" <prabhakar.csengg@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2659.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 6eefb8bbb5b5..20e3c56991cf 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1137,7 +1137,7 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 #else
-		return -ENOTTY;
+		ret = -ENOTTY;
 #endif
 	} else {
 		s64 val;
-- 
2.20.1

