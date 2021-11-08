Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAB544A227
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhKIBQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242910AbhKIBOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EFD361AD0;
        Tue,  9 Nov 2021 01:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419955;
        bh=HHNgnnC0YH+UQ2SkIlv++jtsxO7zKOpuQ4wWcjuxFCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8uOdoWHBChJ7itRoPun0CxCIH4UizQKVl7ucfkj3TPnZHEjHl13njjMKw7c6jWec
         Fn2zwARUPFgW1wFkzRY6iFHVq3/eYbcoO87g+c7wo0Zib1tNhntC4VvETy1ZQsOabb
         8T/KZsfoAiw7nelWl5eH84kxuyzL4GY9i2ndYCWbbC1qAz5VonRl6xXmOuXxbtgQHM
         /vDS/zMoaMKqJiOQBJREB4yfTEU1yVmq6vXfCW61hMIZVu8iHX0sS6kmzwiCB8R/HR
         w+7DHOQVkhE0oGDqEnIKPMPlMTf/9zDTDPf1TNZLmEMOWSAiirNELFniw9/clnRuka
         XnPYPlYEbUwbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, niklas.soderlund@ragnatech.se,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/47] media: rcar-csi2: Add checking to rcsi2_start_receiver()
Date:   Mon,  8 Nov 2021 12:50:06 -0500
Message-Id: <20211108175031.1190422-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit fc41665498332ad394b7db37f23e9394096ddc71 ]

If rcsi2_code_to_fmt() return NULL, then null pointer dereference occurs
in the next cycle. That should not be possible now but adding checking
protects from future bugs.
The patch adds checking if format is NULL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index dc5ae8025832a..23f55514b002a 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -474,6 +474,8 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 
 	/* Code is validated in set_fmt. */
 	format = rcsi2_code_to_fmt(priv->mf.code);
+	if (!format)
+		return -EINVAL;
 
 	/*
 	 * Enable all Virtual Channels.
-- 
2.33.0

