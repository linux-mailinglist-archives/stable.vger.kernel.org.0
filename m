Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341CE420ED7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhJDN27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237208AbhJDN1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F2F61C45;
        Mon,  4 Oct 2021 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353133;
        bh=vCYvbxxUfu3r1PHqy9vG4SyDwYMIRage6wjRef5qy7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0V8skImqxA9qbWVLTgucquQfVcgDfpqgs+TXiOn4x99x3wxE4pf0Ce5S3gooYLhn
         xhWUuRvtI59B+g07he70wZ+GZf2GSUBjHlo4hlC/c5DrH7hFZjdJJ3QiaFEBU2bl88
         LT5e7HUMYiaekmavfJoyDZnQCfRcewp800AaaiEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Emil Velikov <emil.velikov@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 001/172] media: hantro: Fix check for single irq
Date:   Mon,  4 Oct 2021 14:50:51 +0200
Message-Id: <20211004125044.998204905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 31692ab9a9ef0119959f66838de74eeb37490c8d ]

Some cores use only one interrupt and in such case interrupt name in DT
is not needed. Driver supposedly accounted that, but due to the wrong
field check it never worked. Fix that.

Fixes: 18d6c8b7b4c9 ("media: hantro: add fallback handling for single irq/clk")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 31d8449ca1d2..fc769c52c6d3 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -918,7 +918,7 @@ static int hantro_probe(struct platform_device *pdev)
 		if (!vpu->variant->irqs[i].handler)
 			continue;
 
-		if (vpu->variant->num_clocks > 1) {
+		if (vpu->variant->num_irqs > 1) {
 			irq_name = vpu->variant->irqs[i].name;
 			irq = platform_get_irq_byname(vpu->pdev, irq_name);
 		} else {
-- 
2.33.0



