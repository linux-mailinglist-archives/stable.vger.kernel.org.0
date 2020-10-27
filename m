Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7C29B2A4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762651AbgJ0Onw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762647AbgJ0Onv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:43:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BEEE206B2;
        Tue, 27 Oct 2020 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809830;
        bh=pEcuukP1EntrnDVa20u60O7w1UUKqI6OwYX4e7li4o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFKAWSgVQcTFRo9HwdoNfXpzHuCR9XUABWuFrYjQmUflrnIVBqNUm0dXRPbUZVoQc
         pWvoWFJ12gTuSCu5XwSaiknffdGoHP63pGYDF709Bqes2n4WU7qGBXKkKEENBGmXks
         wfakoWThV9sjYMZjs2rwQQ6iee14f6iU7loXoK4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 334/408] media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
Date:   Tue, 27 Oct 2020 14:54:32 +0100
Message-Id: <20201027135510.529823544@linuxfoundation.org>
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

[ Upstream commit c47f7c779ef0458a58583f00c9ed71b7f5a4d0a2 ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
reference count before returning the error.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 2f90607c3797d..a07d796f63df0 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -484,8 +484,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		return -ENXIO;
 
 	ret = pm_runtime_get_sync(fmd->pmf);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(fmd->pmf);
 		return ret;
+	}
 
 	fmd->num_sensors = 0;
 
-- 
2.25.1



