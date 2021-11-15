Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9DF4520DE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbhKPA4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245671AbhKOTVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB46E61B32;
        Mon, 15 Nov 2021 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001537;
        bh=hCBZVbn5ACGsSoRa85leu+ceg8jHthpi32UI/d/3jZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wloc6EiAVJZdFvct6ZG/afGBsdgk2ogjIhHGG8We+ViBaSR3PXmHwhlT5OYxgm+DD
         5N6pdLI9Y2RUe1TJhGksitrn6uYH10ucNdmQX4wA6ShOr9TWq++Qf9IsC2tlbRqo1R
         dCoaQgwuGAjghu7n9Boduq/44sJNJwF9R97Tbj1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/917] media: s5p-mfc: Add checking to s5p_mfc_probe().
Date:   Mon, 15 Nov 2021 17:55:22 +0100
Message-Id: <20211115165436.488480054@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index c763c0a03140c..f336a95432732 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1288,6 +1288,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
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



