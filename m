Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5DB29C511
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824153AbgJ0SDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901118AbgJ0OTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:19:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B7F206D4;
        Tue, 27 Oct 2020 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808342;
        bh=HjDjRoM+9LoTNcODNR3DCKKTzRuvkxrD+PCQkn1DLoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=li5ApvmUnL2TUtHIMeGFMHEt01so4rAsj7CmFI4/GFUd/F+6JrSBlvhIslisGFtzn
         R5DHt9BulJHOAthpiy6jxyQivTlDESra8Dwn2JBZOH8dv5qY3hH0kWuV2N8TECPKfT
         DbdldHTVu6R86TgJTUlzt1J8UTv3eBObBZ24wV80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/264] media: rockchip/rga: Fix a reference count leak.
Date:   Tue, 27 Oct 2020 14:51:54 +0100
Message-Id: <20201027135433.305961116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 884d638e0853c4b5f01eb6d048fc3b6239012404 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus call pm_runtime_put_noidle()
if pm_runtime_get_sync() fails.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index 356821c2dacf0..0932f1445deab 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -89,6 +89,7 @@ static int rga_buf_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	ret = pm_runtime_get_sync(rga->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(rga->dev);
 		rga_buf_return_buffers(q, VB2_BUF_STATE_QUEUED);
 		return ret;
 	}
-- 
2.25.1



