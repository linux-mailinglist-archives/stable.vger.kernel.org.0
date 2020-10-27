Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6929C6B7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753812AbgJ0SWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753840AbgJ0OCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:02:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F9522258;
        Tue, 27 Oct 2020 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807358;
        bh=P/W774Mh4AagQpUC0njjI77RWTZ6pF0peKq7+an9m8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXT3agEoezaJYYO6uxwHfYyomi2wwVfZTujWvjnC1HS8pAgrB+/Fz7oAW0NX4xcJO
         QjZsCGjdr9BUaWRUqhUgUh0/cKBPyWlRMtF/Q5EIcdrzBlYX6oIks9JHy4QuFaK0dO
         vQxFd5LzFsVd5/GyjRRXcPorPrpqIJjirkY80+FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 023/139] media: ti-vpe: Fix a missing check and reference count leak
Date:   Tue, 27 Oct 2020 14:48:37 +0100
Message-Id: <20201027134903.235622406@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
index dbb4829acc438..360a2ad14ce42 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2133,6 +2133,8 @@ static int vpe_runtime_get(struct platform_device *pdev)
 
 	r = pm_runtime_get_sync(&pdev->dev);
 	WARN_ON(r < 0);
+	if (r)
+		pm_runtime_put_noidle(&pdev->dev);
 	return r < 0 ? r : 0;
 }
 
-- 
2.25.1



