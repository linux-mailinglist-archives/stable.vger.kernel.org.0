Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC81029B6D9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368744AbgJ0P1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797960AbgJ0PZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D172064B;
        Tue, 27 Oct 2020 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812322;
        bh=AevS3VJiIWV6RWC+KJ2jiUeCQrep6DzQMeOmMC+G+wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koThp75inqLEM9AZoI3Vt+HA8q3qXGP0KT6pUgzyE/JIFnWinpW+flnxaEiu5bVVQ
         W1JB2rkE/9nnn4chKxnp4mVoIY7HA0aodIums1pYW4uVidh0Iz01Ee4wjRgJ8qP7Wk
         Rmg9Srj5NX/Crn3d9kx2kkLlFOBvfbp0lh6Apk4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 168/757] media: platform: fcp: Fix a reference count leak.
Date:   Tue, 27 Oct 2020 14:46:58 +0100
Message-Id: <20201027135458.476387225@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 63e36a381d92a9cded97e90d481ee22566557dd1 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Fixes: 6eaafbdb668b ("[media] v4l: rcar-fcp: Keep the coding style consistent")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-fcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 5c6b00737fe75..05c712e00a2a7 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -103,8 +103,10 @@ int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 		return 0;
 
 	ret = pm_runtime_get_sync(fcp->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(fcp->dev);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.25.1



