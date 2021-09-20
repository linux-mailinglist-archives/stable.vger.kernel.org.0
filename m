Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A48412231
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348493AbhITSNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359643AbhITSKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAAC61A4E;
        Mon, 20 Sep 2021 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158393;
        bh=jNfagrwBB6tBxwk5PwVadgQlBB9yK8VvqcvtDl0vPX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/jJf9kh1Nql0VyWdaR8ulUh3NFLY025kumycmnBk6hLxBb4Jjf/m0ZjRiwkFJHKg
         d6SwJZeWti0EXNhjDsUm/E8+gAUzhVKgiaUUIsODaspaPHp/wqEA3H0AUZKoBUxcyS
         8zsDEd7xWYAuyhWIg0htOUrJc0oOBM4gynKHLZWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Umang Jain <umang.jain@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/260] media: imx258: Limit the max analogue gain to 480
Date:   Mon, 20 Sep 2021 18:42:16 +0200
Message-Id: <20210920163935.142425118@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit f809665ee75fff3f4ea8907f406a66d380aeb184 ]

The range for analog gain mentioned in the datasheet is [0, 480].
The real gain formula mentioned in the datasheet is:

	Gain = 512 / (512 – X)

Hence, values larger than 511 clearly makes no sense. The gain
register field is also documented to be of 9-bits in the datasheet.

Certainly, it is enough to infer that, the kernel driver currently
advertises an arbitrary analog gain max. Fix it by rectifying the
value as per the data sheet i.e. 480.

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx258.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 5f5e50c01b12..ffaa4a91e571 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -46,7 +46,7 @@
 /* Analog gain control */
 #define IMX258_REG_ANALOG_GAIN		0x0204
 #define IMX258_ANA_GAIN_MIN		0
-#define IMX258_ANA_GAIN_MAX		0x1fff
+#define IMX258_ANA_GAIN_MAX		480
 #define IMX258_ANA_GAIN_STEP		1
 #define IMX258_ANA_GAIN_DEFAULT		0x0
 
-- 
2.30.2



