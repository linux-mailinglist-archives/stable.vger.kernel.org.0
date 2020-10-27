Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1392929C2FC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821131AbgJ0Rkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902310AbgJ0Ocj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2EA22202;
        Tue, 27 Oct 2020 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809157;
        bh=W01PQkn4hXzssp9aLbPMeyOr6BP999eNsYz3WUgp0Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvcJOyiEWHPabFZpwgKxa+0oS36+JY7xCpIWktb8Arf3i93jmO5T+KrMRDbvdPE/Z
         5kP7001zes68SizRtOjQGMGPcGx4Jb0LzH1WRK08Mscqb7iHTsJPPEW6++rjDIq2Me
         pY07Nw/CEzWeNRMQQN+IQ43a0m1qCVIlQyLkg0WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/408] media: ti-vpe: Fix a missing check and reference count leak
Date:   Tue, 27 Oct 2020 14:50:35 +0100
Message-Id: <20201027135459.593569339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 7dae2aaaf432767ca7aa11fa84643a7c2600dbdd ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
And also, when the call of function vpe_runtime_get() failed,
we won't call vpe_runtime_put().
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails
inside vpe_runtime_get().

Fixes: 4571912743ac ("[media] v4l: ti-vpe: Add VPE mem to mem driver")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 8b14ba4a3d9ea..817bd13370eff 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2435,6 +2435,8 @@ static int vpe_runtime_get(struct platform_device *pdev)
 
 	r = pm_runtime_get_sync(&pdev->dev);
 	WARN_ON(r < 0);
+	if (r)
+		pm_runtime_put_noidle(&pdev->dev);
 	return r < 0 ? r : 0;
 }
 
-- 
2.25.1



