Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528EE45BFA6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347589AbhKXNAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347444AbhKXM6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F9C6023E;
        Wed, 24 Nov 2021 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757228;
        bh=fGFQjNNUdNrz52vfi3x9I5L+GYEXW1Vh5yiXJ8d4EGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbEIoaIZhq5Kom58HZcPiX6eaP1BFHlQzUdniw6FvoEt1D1KR1Mezpl+RAbSYq6Pv
         K0yDB0hjI9MxB5VesvlSrEq9f1yxqOnd9qW8zfe6dhFJQ0hKt+jNloFIiSowkmw/C0
         sP1rEVS6n1p0+I8KkCAXTLjJ3WwiDr9Y8VQbc3KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/323] media: s5p-mfc: Add checking to s5p_mfc_probe().
Date:   Wed, 24 Nov 2021 12:54:49 +0100
Message-Id: <20211124115722.309923477@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit cdfaf4752e6915a4b455ad4400133e540e4dc965 ]

If of_device_get_match_data() return NULL,
then null pointer dereference occurs in  s5p_mfc_init_pm().
The patch adds checking if dev->variant is NULL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 80bb58d31c3f6..0fc101bc58d67 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1281,6 +1281,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 
 	dev->variant = of_device_get_match_data(&pdev->dev);
+	if (!dev->variant) {
+		dev_err(&pdev->dev, "Failed to get device MFC hardware variant information\n");
+		return -ENOENT;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
-- 
2.33.0



