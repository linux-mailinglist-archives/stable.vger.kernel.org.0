Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D691C29C1A1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775319AbgJ0R0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780082AbgJ0Oxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8172071A;
        Tue, 27 Oct 2020 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810428;
        bh=VHdgOiu0cFIaKnbNnwJm16vfEUKRWoUX+lJJ1TXbTuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvS1G0gC4k34GT/0wISFq+h6gEppJjxV0kDdko5b+xhRPHQ9Vw+8uuidLqZvlZ54d
         EPrnDcxT04AA+eQS7dmL2RP5CKsyW/5L2rwGw/mAgdtoeOM6RD1EDbYIU2VrtoCmV/
         1lNqJuWowI/paEjFmWwhb/+VfW65gLzAqHaxw8WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Fabio Estevam <festevam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 135/633] media: mx2_emmaprp: Fix memleak in emmaprp_probe
Date:   Tue, 27 Oct 2020 14:47:58 +0100
Message-Id: <20201027135529.025055274@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 21d387b8d372f859d9e87fdcc7c3b4a432737f4d ]

When platform_get_irq() fails, we should release
vfd and unregister pcdev->v4l2_dev just like the
subsequent error paths.

Fixes: d4e192cc44914 ("media: mx2_emmaprp: Check for platform_get_irq() error")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mx2_emmaprp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index df78df59da456..08a5473b56104 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -852,8 +852,11 @@ static int emmaprp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pcdev);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto rel_vdev;
+	}
+
 	ret = devm_request_irq(&pdev->dev, irq, emmaprp_irq, 0,
 			       dev_name(&pdev->dev), pcdev);
 	if (ret)
-- 
2.25.1



